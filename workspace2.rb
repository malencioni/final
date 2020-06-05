

<div class="background">
<div class="container main-contain">
<div class="container box-float">

<div class="row">
    <div class="col-7">
        <div class="container">
            <div class="row">
                <div class="col">
                    <h1><%= @winery[:name] %><span class="pull-right" style="padding-left: 20px;">
                    <a href="/winery/<%= @winery[:wid] %>/check_in/new" class="btn btn-primary" style="padding: 4px; font-size: 15px;">Check In</a></span></h1>
                    <p><%= @winery[:description] %></p>
                </div>
            </div>
        </div>
        <div class="container" style="padding-top:30px;">
            <div class="row">
                <div class="col">
                    <h4>Wines</h4>
                </div>      
            </div>
            <div class="row" style="padding-top:10px;">
                <% @winecategory_count = 1 %>
          

                <% for categories in @winecategory_table %>
                    <div class="col">
                        <% @wine_category = @winecategory_table.where([:wcid] => @winecategory_count)%>
                         <% @wine_category = @winecategory_table.where([:wcid] => @winecategory_count).to_a[0]%>
                         <h5 class="border-bottom"> <%= @wine_category[:description] %></h5>
                        <ul class="nobull">
                            <% for type in @winerywines_table%>
                                <% @wines_types = @winetypes_table.where(:wtid => type[:wtid]).where(:wcid => @winecategory_count).to_a[0]%>
                                <% unless @wines_types.nil? %>
                                <li style="font-size:15px;"><%= @wines_types[:description] %></li>
                            <% end %>

                        <% end %>
                        </ul>
                    </div>
                    <% @winecategory_count =  @winecategory_count + 1 %>
                <%end%>
            </div>
        </div>
    </div>

    <div class="col-5">
        <div class="row">
            <div class="col">
                <img src="/images/<%=@winery[:image]%>.jpg" class="img-fluid" style="padding-bottom:10px;" alt="Responsive image">
                <img src="/images/<%=@winery[:image]%>.jpg" class="img-fluid" style="padding-bottom:10px;" alt="Responsive image">
            </div>
        </div>
    </div>

</div>
<div class="row">
    <div class="col-lg-7">
        <div class="container">
            <h5 style="margin-bottom: 0rem; margin-top: 1.5rem;">Reviews<span class="pull-right" style="padding-left: 10px;">
            <a style="font-size: 12px;">Rating: <%= @avg_rating %></a>
            </span></h5>
            <p style="margin-bottom: 0.5rem;">Visits: <%= @visit_count %></p>
            <% for comment in @review %>
                <div class="container border-top">
                <% @reviewers = @users_table.where(:uid => comment[:uid]).to_a[0]%>
                <% unless @reviewers.nil? %>
                    <div style="padding-top:5px;">
                    <a><%= comment[:rating] %></a>
                    <p style="padding-top:5px; padding-bottom:5px"><%= comment[:review] %></p>
                    <% if @current_user.nil? %>
                        <p style="text-align:right; font-style: italic; font-size:15px">name hidden</p>
                    <%else%>
                        <p style="text-align:right; font-style: italic; font-size:15px">-<%= @reviewers[:fname]%> <%= @reviewers[:lname]%></p>
                    <%end%>
                    </div>
                <%end%>
                </div>
            <% end %>
        </div>
    </div>
    <div class="col-lg-5">
        <h4>Address</h4>
                    <a target="_blank" href="https://www.google.com/maps/search/?api=1&query=<%= @winery[:address1]%>+<%= @winery[:city]%> + <%= @winery[:state]%> + <%= @winery[:zip]%>"><%= @winery[:address1]%>, <%= @winery[:city]%>, <%= @winery[:state]%> <%= @winery[:zip]%></a>
                    <div class="row" style="padding-top: 10px;" >
                        <div class="col">
                            <a class="btn btn-primary" target="_blank" href= "<%=@website%>" role="button" style="padding: 4px; font-size: 12px;">Visit Website</a>
                        </div>
                    </div>
    </div>
</div>



</div>
</div>
</div>