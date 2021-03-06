# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "geocoder"                                                                    #
require "bcrypt"                                                                      #
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
    @wineries = wineries_table.all
    @regions_table = regions_table 
    puts @current_user.inspect
end

# Home page (all wineries)
get "/" do
    # before stuff runs
    @wineries = wineries_table.all
    @regions_table = regions_table 
    view "wineries"
end

# Show a single winery
get "/wineries/:wid" do
    @users_table = users_table
    # SELECT * FROM events WHERE id=:id
    @winery = wineries_table.where(:wid => params["wid"]).to_a[0]
    # SELECT * FROM rsvps WHERE event_id=:id
    @visits = visits_table.where(:vid => params["vid"]).to_a
    # SELECT COUNT(*) FROM rsvps WHERE event_id=:id AND going=1
    @visit_count = visits_table.where(:wid => params["wid"]).count
    @winerywines_table = winerywines_table.where(:wid => params["wid"]).to_a
    @winerywines_table2 = winerywines_table
    @winetypes_table = winetypes_table
    @winecategory_table = winecategory_table
    @winecategory_count = 1
    @sum_rating = visits_table.where(:wid => params["wid"]).sum(:rating)
    @avg_rating = @sum_rating/@visit_count
    @review = visits_table.where(:wid => params["wid"]).to_a
    @website = @winery[:website]
    @test_number = 1
    @sent_message = nil


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
    @users_table = users_table
    # SELECT * FROM events WHERE id=:id
    @winery = wineries_table.where(:wid => params["wid"]).to_a[0]
    # SELECT * FROM rsvps WHERE event_id=:id
    @visits = visits_table.where(:vid => params["vid"]).to_a
    # SELECT COUNT(*) FROM rsvps WHERE event_id=:id AND going=1
    @visit_count = visits_table.where(:wid => params["wid"]).count
    @winerywines_table = winerywines_table.where(:wid => params["wid"]).to_a
    @winerywines_table2 = winerywines_table
    @winetypes_table = winetypes_table
    @winecategory_table = winecategory_table
    @winecategory_count = 1
    @sum_rating = visits_table.where(:wid => params["wid"]).sum(:rating)
    @avg_rating = @sum_rating/@visit_count
    @review = visits_table.where(:wid => params["wid"]).to_a
    @website = @winery[:website]
    @test_number = 1
    @sent_message = "Your message has been sent"
    view "winery"

end
    