, :wtid=>1  <% for wine in @winerywines_table.where(wcid =>1) %>
    <% wine_type = red_wine.where(:wtid => wine[:wtid]).to_a[0]%>
    <p> <%= wine_type[:description] %>  <%= wine_type[:wcid] %> </p>



    <h6>White</h6>
    <% for wine in @winerywines_table%>
    <% @wines = @winetypes_table.where(:wtid => wine[:wtid]).where(:wcid => 2).to_a[0]%>
            <%  unless @wines.nil? %>
            <p><%= @wines[:description] %></p>
            <% end %>
    <% end %>


      <label>Comments</label>
    <textarea class="form-control" rows="3" name="comments"></textarea>


     <%= type[:vintage] %> <%= type[:name] %>: <%= type[:price] %>
     @wine = winerywines_table.where(:wid => params["wid"]).to_a


     <% for wine in @winerywines_table%>
                            <% @wine_types = @winetypes_table.where(:wtid => wine[:wtid]).where(:wcid => @winecategory_count).to_a[0]%>
                            <% unless @wine_types.nil? %>
                                <% @winery_wine_categories = @winecategory_table.where(:wcid => @wine_types[:wcid]).to_a[0] %>
                                    <% unless @winery_wine_categories.nil? %>
                                        <h5 class="border-bottom"> <%= @winery_wine_categories[:description] %></h5>
                                    <%end%>
                            <%end%>
                        <%end%>



    client.messages.create(
        from: "+12013576950", 
        to: "+16306772817",
        body: "Hey KIEI-451!"
        )


        get "/send_text/:wid" do
to "/wineries/:wid"
     client.messages.create(
        from: "+12013576950", 
        to: @number,
        body: "Hey KIEI-451!"
        )
    @number = "+1x"

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
    if @current_user.nil?
        @sign_in_first = "You need to sign in first"
    end
    view "winery"

end
    

     client.messages.create(
        from: "+12013576950", 
        to: @number,
        body: "Hey KIEI-451!"
        )


                                <% @winery_winecategory2 = @winetypes_table3.where([:wcid] => @wine_category[:wcid]) %>
                        <% @thisthatandanother = @winerywines_table2.where([:wid] => params["wid"])%>
                        <% @thisthatandanother1 = @thisthatandanother#{:wid}
                        <% @thatotherthing =  @thisthatandanother.where([:wtid] => @winery_winecategory2[:wtid])%>



ps_endpoint = ENV['EINSTEIN_VISION_URL']
subject = ENV['EINSTEIN_VISION_ACCOUNT_ID']
private_key = String.new(ENV['EINSTEIN_VISION_PRIVATE_KEY'])
private_key.gsub!('\n', "\n")
expiry = Time.now.to_i + (60 * 15)

# Read the private key string as Ruby RSA private key
rsa_private = OpenSSL::PKey::RSA.new(private_key)

# Build the JWT payload
payload = {
        :sub => subject,
        :aud => "https://api.einstein.ai/v2/oauth2/token",
        :exp => expiry
    }

# Sign the JWT payload
assertion = JWT.encode payload, rsa_private, 'RS256'
puts assertion

# Call the OAuth endpoint to generate a token
response = RestClient.post(ps_endpoint + 'v2/oauth2/token', {
        grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        assertion: assertion
    })

token_json = JSON.parse(response)
puts "\nGenerated access token:\n"
puts JSON.pretty_generate(token_json)

access_token = token_json["access_token"]

#######################################################################################