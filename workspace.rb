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