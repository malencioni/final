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