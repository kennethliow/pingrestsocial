<%@page import="controllers.AlbumController"%>
<%@page import="models.User"%>
<div class="col-sm-3 col-md-2 sidebar hidden-xs">
    <ul class="nav nav-sidebar">
        <li class="nav-logo"> <img class="img-responsive center-block" src="assets/images/hashedwhite-logo.png"/></li>
    </ul>

    <div class="section_holder">
        <ul class="nav nav-sidebar">
            <% if (session.getAttribute("location") == "explore") {%>
            <li class="active">
                <% } else {%>
                <li class="">
                    <% }%>
                    <a href="explore.jsp" id="explore-tab">Explore</a>
                </li>
            </ul>
        </div>
        <div class="section_holder">
            <ul class="nav nav-sidebar">
                <% if (session.getAttribute("location") == "albums") {%>
                <li class="active">
                    <% } else {%>
                    <li class="">
                        <% }%>
                        <a href="albums.jsp" id="albums-tab">Albums 
                            <% if (AlbumController.getTaggedAlbumsList().size() != 0) {%> 
                            <span class="badge pull-right"><%=AlbumController.getTaggedAlbumsList().size()%> new tags</span>
                            <%}%>
                        </a>
                    </li>
                </ul>
            </div>
            <div class="section_holder">
                <ul class="nav nav-sidebar">
                    <% if (session.getAttribute("location") == "groups") {%>
                    <li class="active">
                        <% } else {%>
                        <li class="">
                            <% }%>
                            <a href="groups.jsp" id="groups-tab">Groups</a>
                        </li>
                    </ul>
                </div>

                <div id="user_menu">
                    <% User user = (User) session.getAttribute("user"); %>


                    <div id="current_user_avatar"><img class="member_image img-rounded" src=<%=user.getProfilePicture()%>>
                        <a id="current_user" class="overflow-ellipsis" href="index.html">@<%=user.getUsername()%></a>
                        <i class="glyphicon glyphicon-log-out sidebarmenuicon" data-toggle="modal" data-target="#logoutModal"></i>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog">
                <div class="modal-dialog modal-alert">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>

                        </div>
                        <form class="form-horizontal" action="LogoutServlet">
                           <div class="modal-body">
                            <h4 class="center-text">Are you sure you want to sign out?</h4>

                            <div class="modalbuttonsDiv center-text">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            <input type="submit" class="btn btn-pink" value="Sign Out"></div>
                        </div>
                    </form>
                </div>
            </div>
        </div>