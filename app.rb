# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "geocoder"                                                                    #
require "bcrypt"  
require 'jwt'
require 'rest-client'
require 'json'                                                                    #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################




# events_table = DB.from(:events)
# rsvps_table = DB.from(:rsvps)
wineries_table = DB.from(:wineries)
favorites_table = DB.from(:favorites)
regions_table = DB.from(:regions)
visits_table = DB.from(:visits)
users_table = DB.from(:users)
winetypes_table = DB.from(:winetypes)
winecategory_table = DB.from(:winecategory)
winerywines_table = DB.from(:winerywines)


account_sid = ENV["TWILIO_ACCOUNT_SID"]
auth_token = ENV["TWILIO_AUTH_TOKEN"]
client = Twilio::REST::Client.new(account_sid, auth_token)

before do
    # SELECT * FROM users WHERE id = session[:user_id]
    @current_user = users_table.where(:uid => session[:uid]).to_a[0]
    @wineries = wineries_table.order_by(:name)
    @regions_table = regions_table 
    puts @current_user.inspect
end

# Home page (all wineries)
get "/" do
    # before stuff runs
    @regions_table = regions_table 
    view "wineries"
end

# Show a single winery
get "/wineries/:wid/?:button_push?" do
    @users_table = users_table
    # SELECT * FROM events WHERE id=:id
    @winery = wineries_table.where(:wid => params["wid"]).to_a[0]
    # SELECT * FROM rsvps WHERE event_id=:id
    @visits = visits_table.where(:vid => params["vid"]).to_a
    # SELECT COUNT(*) FROM rsvps WHERE event_id=:id AND going=1
    @visit_count = visits_table.where(:wid => params["wid"]).count
    @winerywines_table = winerywines_table.where(:wid => params["wid"]).to_a
    @winetypes_table = winetypes_table.order_by(:description)
    @winecategory_table = winecategory_table
    @winecategory_count = 1
    @sum_rating = visits_table.where(:wid => params["wid"]).sum(:rating)
    @avg_rating_gross = @sum_rating/@visit_count
    @avg_rating = @avg_rating_gross.round(0) 
    @review = visits_table.where(:wid => params["wid"]).to_a
    @website = @winery[:website]
    @test_number = 1
    @winery_name_table = wineries_table.where(:wid => params["wid"]).to_a[0]
    @visits_table = visits_table
    @rating_5 = visits_table.where(:wid => params["wid"]).where(:rating => "5").count
    if params["button_push"].nil?
        @button_push = nil
    else
        @button_push = params["button_push"]
    end

    view "winery"
end

# Form to create a new user
get "/users/new" do
    view "new_user"
end


# Receiving end of new user form
post "/users/create" do
    @email_exists = users_table.where(:email => params["email"]).to_a[0]
        puts @email_exists

    if @email_exists.nil?
        users_table.insert(:fname => params["fname"],
            :lname => params["lname"],
            :email => params["email"],
            :password => BCrypt::Password.create(params["password"]),
            :phone => params["phone"],
            :city => params["city"],
            :state => params["state"],
                        )
        view "create_user"
    else
        @you_exist_message = "Email address already associated with an account, please login."
        view "new_login"
    end
end


# Form to login
get "/logins/new" do
    view "new_login"
end

# Receiving end of login form
post "/logins/create" do
    puts params
    email_entered = params["email"]
    password_entered = params["password"]
    # SELECT * FROM users WHERE email = email_entered
    user = users_table.where(:email => email_entered).to_a[0]
    if user
        puts user.inspect
        # test the password against the one in the users table
        if BCrypt::Password.new(user[:password]) == password_entered
            session[:uid] = user[:uid]
            view "create_login"
        else
            view "create_login_failed"
        end
    else 
        view "create_login_failed"
    end
end

# Logout
get "/logout" do
    session[:uid] = nil
    view "logout"
end

# Form to create a new checkin
get "/winery/:wid/check_in/new" do
    @winery = wineries_table.where(:wid => params["wid"]).to_a[0]
    if @current_user.nil?
        @new_guy_message = "You must be logged in to check in to a winery"
        view "new_login"
    else
        view "new_checkin"
    end
end

# Receiving end of new checkin form
post "/winery/:wid/check_in/create" do
    visits_table.insert(:wid => params["wid"],
                    :uid => @current_user[:uid],
                    :visit_date => params["date"],
                    :rating => params["rating"],
                    :review => params["review"])
    @winery = wineries_table.where(:wid => params["wid"]).to_a[0]
    view "create_checkin"
end

get "/send_text/:wid" do
    @winery_name_table = wineries_table.where(:wid => params["wid"]).to_a[0]
    @winery = wineries_table.where(:wid => params["wid"]).to_a[0]
    unless @current_user.nil?
        @user_phone = @current_user[:phone]
        @check_phone = users_table.where([:uid]=>"3").to_a[0]
    end
    view "new_text"
end

get "/create_text/:wid" do
    @winery_name_table = wineries_table.where(:wid => params["wid"]).to_a[0]
    @winery = wineries_table.where(:wid => params["wid"]).to_a[0]
    unless @current_user.nil?
        @user_phone = @current_user[:phone]
        @check_phone = users_table.where([:uid]=>"3").to_a[0]
            @number = "+1".concat(@user_phone)
            @sms_body = @winery_name_table[:name].concat(" - ").concat(@winery[:address1]).concat(", ").concat(@winery[:city]).concat(", ").concat(@winery[:state]).concat(" ").concat(@winery[:zip]).concat(" - ").concat(@winery[:website])
            client.messages.create(
                from: "+12013576950", 
                to: @number,
                body: @sms_body
                )
    end
    view "create_text"
end
    
# View Your Account
get "/account/:uid" do
    @users_table = users_table
    @user_review = visits_table.where(:uid => params["uid"]).to_a
    @wine_spot = wineries_table
    view "my_account"
end

# View All Wineries
get "/all/wineries" do
    @regions_table2 = regions_table
    @wineries_place1 = wineries_table.order_by(:name)
    @visits_table = visits_table
    view "wineries_all"
end
