# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
# DB.create_table! :events do
#   primary_key :id
#   String :title
#   String :description, text: true
#   String :date
#   String :location
# end
# DB.create_table! :rsvps do
#   primary_key :id
#   foreign_key :event_id
#   Boolean :going
#   String :name
#   String :email
#   String :comments, text: true
# end

DB.create_table! :wineries do
  primary_key :wid
  foreign_key :reid
  String :name
  String :description, text: true
  String :address1
  String :address2
  String :city
  String :state
  String :zip
  String :website
end

DB.create_table! :favorites do
  primary_key :fid
  foreign_key :wid
  foreign_key :uid
end

DB.create_table! :ratings do
    primary_key :rid
    foreign_key :wid
    foreign_key :uid
    Integer :rating
    Date :rating_date
    String :review, text: true
end

DB.create_table! :regions do
    primary_key :reid
    String :description
end

DB.create_table! :visits do
    primary_key :vid
    foreign_key :wid
    foreign_key :uid
    Date :visit_date
end

DB.create_table! :users do
    primary_key :uid
    String :fname
    String :lname
    String :email
    String :password
    String :city
    String :state
end

DB.create_table! :winetypes do
    primary_key :wtid
    foreign_key :wcid
    String :description
end

DB.create_table! :winerywines do
    foreign_key :wid
    foreign_key :wtid
end

DB.create_table! :winecategory do
    foreign_key :wcid
    String :description
end

# Insert initial (seed) data

regions_table = DB.from(:regions)
regions_table.insert(description: "Napa")


regions_table.insert(description: "Sonoma")



wineries_table = DB.from(:wineries)
wineries_table.insert(reid: "1",
                    name: "Seed Winery",
                    description: "This is a test",
                    address1: "123 new rd",
                    city: "Sonoma",
                    state: "CA",
                    zip: "95476",
                    website: "seedwinery.com")


users_table = DB.from(:users)
users_table.insert(fname: "Jim",
                lname: "Cotton",
                email: "jcotton@demo.com",
                password: "test",
                city: "Demoville",
                state: "IL"
                )


favorites_table = DB.from(:favorites)                
favorites_table.insert(wid: "1",
                    uid: "1")


ratings_table = DB.from(:ratings)                    
ratings_table.insert(wid: "1",
                    uid: "1",
                    rating: "5",
                    rating_date: "1/1/2020",
                    review: "This is another test"
                    )


visits_table = DB.from(:visits)
visits_table.insert(wid: "1",
                    uid: "1",
                    visit_date: "1/1/2020"
                    )

winetypes_table = DB.from(:winetypes)
winetypes_table.insert(wtid: "1",
                    wcid: "1",
                    description: "Cabernet Sauvignon"
                    )
winetypes_table.insert(wtid: "2",
                    wcid: "2",
                    description: "Chardonnay"
                    )


winerywines_table = DB.from(:winerywines)
winerywines_table.insert(wid: "1",
                    wtid: "1"
                    )
winerywines_table.insert(wid: "1",
                    wtid: "2"
                    )


winecategory_table = DB.from(:winecategory)
winecategory_table.insert(wcid: "1",
                        description: "Red"
)
winecategory_table.insert(wcid: "2",
                        description: "White"
)

