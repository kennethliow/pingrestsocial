<%@page import="controllers.UserController"%>
<%@page import="controllers.AlbumController"%>
<%@page import="java.util.ArrayList"%>
<%@page import="models.Album"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%session.setAttribute("location", "albums");%>
<!DOCTYPE html>
<html lang="en">
<jsp:include page="album_create.jsp"/> 
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../../favicon.ico">

    <title>#hashed</title>

    <!-- Bootstrap core CSS -->
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="assets/css/hashed.css" rel="stylesheet">
    <link href="assets/css/blockgrid.css" rel="stylesheet">
</head>

<body>

    <div class="container-fluid">
        <div class="row">

            <%@include file="sidebar.jsp"%> 
            
            <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
                <h1 class="page-header">#My Albums</h1>
                
                <% if (session.getAttribute("success") != null) {%>
                <div class="alert alert-success">  
                    <a class="close" data-dismiss="alert">×</a>  
                    <strong><%=session.getAttribute("success")%></strong>  
                </div> 
                
                <% session.removeAttribute("success"); }%>
                
                <% if (session.getAttribute("error") != null) {%>
                <div class="alert alert-danger">  
                    <a class="close" data-dismiss="alert">×</a>  
                    <strong><%=session.getAttribute("error")%></strong>  
                </div> 
                <% session.removeAttribute("error");}%>
                <div class="row">
                    <div class="col-sm-8 col-sm-offset-2 center-text">
                       <div id="welcomeslide">
                        <h1>Albums you created &amp; tagged in!</h1>
                        <p>Click an album to view the photos inside or <a href="#" data-toggle="modal" data-target="#add_new_album">create a new album</a>.</p>
                    </div>
                </div>

                <div class="col-sm-2 albumButton hidden">
                    <button type="button" class="btn btn-pink btn-lg pull-right" data-toggle="modal" data-target="#add_new_album">Add New Album</button>
                </div>

                <div class="row">
                    <div class="col-md-12 col-md-offset-0 col-sm-8 col-sm-offset-2 center-text">

                        <div class="block-grid-lg-6 block-grid-md-5 block-grid-sm-4 block-grid-xs-2 albumthumbnail-row">

                            <div class="block-grid-item">
                                <div class="albumDiv">          
                                    <a href="#" id="newalbumdiv" data-toggle="modal" data-target="#add_new_album"><img src="assets/images/newalbum.png" class="img-responsive img-rounded lazy"/></a>
                                </div>
                            </div>

                            <% ArrayList<Album> albumList = albumController.getAlbumList();
                            UserController userController = appController.getUserController();
                            for (Album album : albumList) {
                            String albumLink = "album.jsp?id=" + album.getAlbumID();
                            String albumCover = album.getAlbumCover();
                            String albumName = album.getName();
                            
                            if (albumCover.equals("")) {albumCover = "http://placehold.it/640x640&text="+albumName;}%>
                            <div class="block-grid-item">

                                <div class="albumDiv">          
                                    <a href=<%=albumLink%>>
                                       <% if (album.getOwner() != userController.getUserLoggedIn()) { %>
                                       <span class="badge pull-right taggedAlbums">Tagged!</span>
                                       <% } %>
                                       <h4 class="albumName overflow-ellipsis"><%=albumName%></h4>
                                       <img src=<%=albumCover%> class="img-responsive img-rounded lazy"/>
                                   </a>
                               </div>
                           </div>
                           <% }%>
                       </div>

                   </div>
               </div>
           </div>
       </div>
   </div>
</div>
        <!-- Bootstrap core JavaScript
        ================================================== -->
        <!-- Placed at the end of the document so the pages load faster -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery.lazyload.min.js" type="text/javascript"></script>

        <script>
        $(document).ready(function() {
            $("img.lazy").show().lazyload();
        });
    </script>
</body>
</html>
