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
ratings_table = DB.from(:ratings)
regions_table = DB.from(:regions)
visits_table = DB.from(:visits)
users_table = DB.from(:users)
winetypes_table = DB.from(:winetypes)
winecategory_table = DB.from(:winecategory)
winerywines_table = DB.from(:winerywines)

before do
    # SELECT * FROM users WHERE id = session[:user_id]
    @current_user = users_table.where(:uid => session[:uid]).to_a[0]
    puts @current_user.inspect
end

# Home page (all wineries)
get "/" do
    # before stuff runs
    @wineries = wineries_table.all
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
    @count = visits_table.where(:wid => params["wid"]).count
    @winerywines_table = winerywines_table.where(:wid => params["wid"]).to_a
    @winetypes_table = winetypes_table
    @winecategory_table = winecategory_table
    @winecategory_count = 1
    view "winery"
end

# Form to create a new user
get "/users/new" do
    view "new_user"
end


# Receiving end of new user form
post "/users/create" do
    users_table.insert(:fname => params["fname"],
                    :lname => params["lname"],
                    :email => params["email"],
                    :password => params["password"],
                    :city => params["city"],
                    :state => params["state"],
                                )
    view "create_user"
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
        if user[:password] == password_entered
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
    view "logout"
end

# Form to create a new checkin
get "/winery/:wid/check_in/new" do
    @winery = wineries_table.where(:wid => params["wid"]).to_a[0]
    view "new_checkin"
end

# Receiving end of new RSVP form
post "/winery/:wid/check_in/create" do
    visits_table.insert(:wid => params["wid"],
                    :uid => @current_user[:uid],
                    :visit_date => params["date"])
    @winery = wineries_table.where(:wid => params["wid"]).to_a[0]
    view "create_checkin"
end
    
    