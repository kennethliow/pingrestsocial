<div class="col-sm-3 col-md-2 sidebar hidden-xs">
    <ul class="nav nav-sidebar">
        <li class="nav-logo"> 
            <img class="img-responsive" src="assets/images/pings_side.jpg" style="width: 30%; display: inline-block;"/>
            <span class="logo-wordings">
                <span style="font-size: 20px;">#IS434</span>
                <br/>Social Analytics
            </span>
        </li>
    </ul>
    <%
        String url = request.getRequestURL().toString();
    %>
    <div class="section_holder">
        <ul class="nav nav-sidebar">
            <li class="<%if(url.indexOf("is434.jsp")>=0){%>active<%}%>">
                <a href="is434.jsp">Overview</a>
            </li>
        </ul>
    </div>
    <div class="section_holder">
        <ul class="nav nav-sidebar">
            <li class="<%if(url.indexOf("fb")>=0){%>active<%}%>">
                <a href="fb_insights.jsp">Facebook Insights</a>
            </li>
            <li class="<%if(url.indexOf("fb_insights")>=0){%>active<%}%>">
                <a href="fb_insights.jsp" style="padding-left: 2em;<%if(url.indexOf("fb_insights")>=0){%>background-color: #ee975d;<%}%>">Demographics</a>
            </li>
            <li class="<%if(url.indexOf("fb_wordcloud")>=0){%>active<%}%>">
                <a href="fb_wordcloud.jsp" style="padding-left: 2em;<%if(url.indexOf("fb_wordcloud")>=0){%>background-color: #ee975d;<%}%>">Hashtag Word Cloud</a>
            </li>
        </ul>
    </div>
    <div class="section_holder">
        <ul class="nav nav-sidebar">
            <li class="<%if(url.indexOf("instagram")>=0){%>active<%}%>">
                <a href="instagram.jsp">Instagram</a>
            </li>
        </ul>
    </div>
    <div class="section_holder">
        <ul class="nav nav-sidebar">
            <li class="<%if(url.indexOf("forum")>=0){%>active<%}%>">
                <a href="forum.jsp">Forum Crawling</a>
            </li>
        </ul>
    </div>
    <div id="user_menu">
        <div id="current_user_avatar"><img class="member_image img-rounded" src="assets/images/anonymousUser.jpg">
            <a id="current_user" class="overflow-ellipsis" href="is434.jsp">Administrator</a>
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
                        <input type="submit" class="btn btn-pink" value="Sign Out">
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>