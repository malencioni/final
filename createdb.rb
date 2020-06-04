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
  String :image
end

DB.create_table! :favorites do
  primary_key :fid
  foreign_key :wid
  foreign_key :uid
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
    Integer :rating
    String :review, text: true
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
    primary_key :wcid
    String :description
end

# Insert initial (seed) data

regions_table = DB.from(:regions)
regions_table.insert(description: "Napa")

regions_table.insert(description: "Sonoma")



wineries_table = DB.from(:wineries)
wineries_table.insert(reid: "1",
                    name: "Sterling Vineyards",
                    description: "Perched 300 feet above the town of Calistoga, Sterling Vineyards offers panoramic views of Napa Valley. An aerial tram carries visitors up the hill to the winery where Sterling founder Peter Newton once lived.",
                    address1: "1111 Dunaweal Lane",
                    city: "Calistoga",
                    state: "CA",
                    zip: "94515",
                    website: "https://www.sterlingvineyards.com/en-us",
                    image: "sterling")

wineries_table.insert(reid: "1",
                    name: "Inglenook Vineyard",
                    description: "The Inglenook legacy began in 1879 when Gustave Niebaum, a Finnish sea captain, wine connoisseur and entrepreneur, came to Rutherford to build a wine estate that would rival Europe’s finest.",
                    address1:"1991 St Helena Highway",
                    city: "Rutherford",
                    state: "CA",
                    zip: "94573",
                    website: "https://www.inglenook.com",
                    image: "inglenook")

wineries_table.insert(reid: "1",
                    name: "Silver Oak",
                    description: "Silver Oak began over a handshake between two friends with a bold vision: focus on one varietal, Cabernet Sauvignon, aged exclusively in American oak and worthy of cellaring for decades to come.",
                    address1: "915 Oakville Cross Rd",
                    city: "Oakville",
                    state: "CA",
                    zip: "94562",
                    website: "https://silveroak.com",
                    image: "silveroak")

wineries_table.insert(reid: "2",
                    name: "Square Peg",
                    description: "Our Estate Vineyard is located in one of the finest sections of the Russian River Valley and is also co-located in 2 additional AVA’s: Green Valley of Russian River Valley and Sonoma Coast.",
                    address1: "4728 Stoetz Ln",
                    city: "Sebastopol",
                    state: "CA",
                    zip: "95472",
                    website: "https://squarepegwinery.com",
                    image: "squarepeg")
                    
wineries_table.insert(reid: "2",
                    name: "Jordan Winery",
                    description: "In a world where successful wineries and wine brands are increasingly owned by corporations, Jordan is proud to be family-owned and operated since 1972.",
                    address1: "1474 Alexander Valley Road",
                    city: "Healdsburg",
                    state: "CA",
                    zip: "95448",
                    website: "https://www.jordanwinery.com",
                    image: "jordan")

wineries_table.insert(reid: "2",
                    name: "Coppola Winery",
                    description: "We’ve always felt that you should know what goes into every bottle of wine. It’s with this philosophy that we created each of our unique experiences, highlighting our award-winning property and portfolio of over sixty wines.",
                    address1: "300 Via Archimedes",
                    city: "Geyserville",
                    state: "CA",
                    zip: "95441",
                    website: "https://www.francisfordcoppolawinery.com",
                    image: "francis")

winerywines_table = DB.from(:winerywines)
winerywines_table.insert(wid: "1",
                    wtid: "1")

#Sterling Wine                    
winerywines_table.insert(wid: "1",
                    wtid: "3")
winerywines_table.insert(wid: "1",
                    wtid: "2")
winerywines_table.insert(wid: "1",
                    wtid: "4")
winerywines_table.insert(wid: "1",
                    wtid: "5")
winerywines_table.insert(wid: "1",
                    wtid: "6")
winerywines_table.insert(wid: "1",
                    wtid: "7")
winerywines_table.insert(wid: "1",
                    wtid: "8")
winerywines_table.insert(wid: "1",
                    wtid: "9")
winerywines_table.insert(wid: "1",
                    wtid: "10")
winerywines_table.insert(wid: "1",
                    wtid: "11")

#Inglenook Wine                    
winerywines_table.insert(wid: "2",
                    wtid: "1")
winerywines_table.insert(wid: "2",
                    wtid: "6")
winerywines_table.insert(wid: "2",
                    wtid: "9")
winerywines_table.insert(wid: "2",
                    wtid: "12")

#Silver Oak Wine
winerywines_table.insert(wid: "3",
                    wtid: "1")

#Square Peg Wine
winerywines_table.insert(wid: "4",
                    wtid: "1")
winerywines_table.insert(wid: "4",
                    wtid: "10")
winerywines_table.insert(wid: "4",
                    wtid: "3")

#Jordan Wine
winerywines_table.insert(wid: "5",
                    wtid: "1")
winerywines_table.insert(wid: "5",
                    wtid: "3")

#Coppola Wine
winerywines_table.insert(wid: "6",
                    wtid: "1")
winerywines_table.insert(wid: "6",
                    wtid: "3")
winerywines_table.insert(wid: "10",
                    wtid: "1")
winerywines_table.insert(wid: "6",
                    wtid: "12")
winerywines_table.insert(wid: "6",
                    wtid: "5")
winerywines_table.insert(wid: "6",
                    wtid: "13")
winerywines_table.insert(wid: "6",
                    wtid: "14")
winerywines_table.insert(wid: "6",
                    wtid: "2")

winetypes_table = DB.from(:winetypes)
winetypes_table.insert(wtid: "1",
                    wcid: "1",
                    description: "Cabernet Sauvignon"
                    )
winetypes_table.insert(wtid: "2",
                    wcid: "1",
                    description: "Merlot"
                    )

winetypes_table.insert(wtid: "5",
                    wcid: "1",
                    description: "Petite Sirah"
                    )

winetypes_table.insert(wtid: "6",
                    wcid: "1",
                    description: "Zinfandel"
                    )
winetypes_table.insert(wtid: "7",
                    wcid: "1",
                    description: "Malbec"
                    )
winetypes_table.insert(wtid: "8",
                    wcid: "1",
                    description: "Cabernet Franc"
                    )
winetypes_table.insert(wtid: "10",
                    wcid: "1",
                    description: "Pinot Noir"
                    )
winetypes_table.insert(wtid: "12",
                    wcid: "1",
                    description: "Syrah"
                    )

winetypes_table.insert(wtid: "3",
                    wcid: "2",
                    description: "Chardonnay"
                    )
winetypes_table.insert(wtid: "9",
                    wcid: "2",
                    description: "Sauvignon Blanc"
                    )
winetypes_table.insert(wtid: "13",
                    wcid: "2",
                    description: "Viognier"
                    )
winetypes_table.insert(wtid: "14",
                    wcid: "2",
                    description: "Rose"
                    )

winetypes_table.insert(wtid: "4",
                    wcid: "3",
                    description: "Rose"
                    )

winetypes_table.insert(wtid: "11",
                    wcid: "3",
                    description: "Brut"
                    )

users_table = DB.from(:users)
users_table.insert(fname: "Jim",
                lname: "Cotton",
                email: "jcotton@demo.com",
                password: "test",
                city: "Demoville",
                state: "IL"
                )

users_table.insert(fname: "John",
                lname: "Smith",
                email: "jsmith@demo.com",
                password: "test",
                city: "Demoville",
                state: "IL"
                )


favorites_table = DB.from(:favorites)                
favorites_table.insert(wid: "1",
                    uid: "1")


visits_table = DB.from(:visits)
visits_table.insert(wid: "1",
                    uid: "1",
                    visit_date: "2020-05-28",
                    rating: "5",
                    review: "This is another test"
                    )

visits_table = DB.from(:visits)
visits_table.insert(wid: "2",
                    uid: "1",
                    visit_date: "2020-05-28",
                    rating: "5",
                    review: "This is another test"
                    )

visits_table = DB.from(:visits)
visits_table.insert(wid: "3",
                    uid: "1",
                    visit_date: "2020-05-28",
                    rating: "5",
                    review: "This is another test"
                    )

visits_table = DB.from(:visits)
visits_table.insert(wid: "4",
                    uid: "1",
                    visit_date: "2020-05-28",
                    rating: "5",
                    review: "This is another test"
                    )

visits_table = DB.from(:visits)
visits_table.insert(wid: "5",
                    uid: "1",
                    visit_date: "2020-05-28",
                    rating: "5",
                    review: "This is another test"
                    )

visits_table = DB.from(:visits)
visits_table.insert(wid: "6",
                    uid: "1",
                    visit_date: "2020-05-28",
                    rating: "5",
                    review: "This is another test"
                    )


winecategory_table = DB.from(:winecategory)
winecategory_table.insert(wcid: "1",
                        description: "Red"
)
winecategory_table.insert(wcid: "2",
                        description: "White"
)
winecategory_table.insert(wcid: "3",
                        description: "Sparkling"
)