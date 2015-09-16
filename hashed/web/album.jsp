<%@page import="models.Group"%>
<%@page import="java.util.HashMap"%>
<%@page import="controllers.UserController"%>
<%@page import="models.Album"%>
<%@page import="controllers.AlbumController"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../../favicon.ico">

    <title>#hashed</title>

    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/hashed.css" rel="stylesheet">
    <link href="assets/css/blockgrid.css" rel="stylesheet">
    <link href="assets/css/bootstrap-select.css" rel="stylesheet">
    <link href="assets/css/bootstrap-select.min.css" rel="stylesheet">
    <link href="assets/css/tag-basic-style.css" rel="stylesheet">
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
    <script src="assets/js/bootstrap-select.js"></script>
    <script src="assets/js/jquery1.8.2.js"></script>
    <script src="assets/js/tagging.min.js"></script>
    
    

</head>
<body>
   
    <div class="container-fluid">
        <div class="row">
            <%@include file="sidebar.jsp"%> 
             <%
            session.setAttribute("location", "albums");
            String albumID = request.getParameter("id");
            Album album = albumController.getAlbumByID(albumID);
            UserController userController = appController.getUserController();
                          
            String albumName = album.getName();
            %>
            <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
                <h1 class="page-header"><a class="backAnchor" href="albums.jsp"><i class="glyphicon glyphicon-chevron-left"></i></a> #<%=albumName%></h1>
                <% if (session.getAttribute("success") != null) {%>
                <div class="alert alert-success">  
                    <a class="close" data-dismiss="alert">×</a>  
                    <strong><%=session.getAttribute("success")%></strong>  
                </div> 
                <% session.removeAttribute("success");}%>
                <% if (session.getAttribute("error") != null) {%>
                <div class="alert alert-danger">  
                    <a class="close" data-dismiss="alert">×</a>  
                    <strong><%=session.getAttribute("error")%></strong>  
                </div> 
            <% session.removeAttribute("error");}%>
            <% ArrayList<String> photoLinks = album.getPhotoLinks();%>

                <div class="row">
                    <% if (photoLinks.isEmpty()) {%>
                    <div class="col-sm-8 col-sm-offset-2 center-text">
                        <div id="welcomeslide">
                            <h1>You're Ready to Go</h1>
                            <p>When you're ready, <a href="explore.jsp">head down to the explore tab and start adding photos to albums!</a>.</p>
                        </div>
                        <span class="btn btn-pink" id="deleteAlbum"><i class="glyphicon glyphicon-trash"></i> Delete Album</span>
                        <form name="delete_album" hidden action="DeleteAlbumServlet" id="delete_album">
                            <input type="text" hidden value='<%=albumID%>' name="albumID">
                        </form>
                    </div>
                    <% } else {
                    boolean isTaggedAlbum =  album.getOwner() != userController.getUserLoggedIn();
                    ArrayList<User> taggedUsers = album.getTaggedUsers(); 
                    ArrayList<String> taggedEmails = album.getTaggedEmails(); 
                    if(!taggedUsers.isEmpty() || !taggedEmails.isEmpty()){%>
                    <div class="col-sm-7">       
                        <p class="taggedMembers">

                            <% if(!isTaggedAlbum){ %>
                            Tagged Users: 
                            <% for (int i = 0; i < taggedUsers.size(); i++) { %>
                            <% User taggedUser = taggedUsers.get(i); %>
                            <span class="label label-default"><%= taggedUser.getUsername() %></span>
                            <% } %>

                            <% for (int i = 0; i < taggedEmails.size(); i++) { %>
                            <% String taggedEmail = taggedEmails.get(i); %>
                            <span class="label label-default"><%= taggedEmail %></span>
                            <% } %>

                            <% }else{ %>
                            You have been tagged in this album by <%= album.getOwner().getUsername() %>!
                            <input type="hidden" id="taggedAlbumhidden" value="true">
                            <% } %>
                        </p>
                    </div>
                    <% } %>
                    <div class="col-sm-5 text-right pull-right">

                        <form action="DownloadServlet" method="POST" style="display:inline;">
                            <button class="btn btn-default" id="downloadAlbum">
                                <i class="glyphicon glyphicon-download-alt" ></i> Download
                                <input type="hidden" id="imagelinks" name ="imagelinks" value='<%=photoLinks.toString()%>'/>
                            </button>
                        </form>

                        <% if(!isTaggedAlbum){ %>
                        <span class="btn btn-info" id="ajaxTagGroupAlbum"><i class="glyphicon glyphicon-share"></i> Share</span>
                        <span class="btn btn-pink hidden" id="removePhotos"><i class="glyphicon glyphicon-remove"></i> Remove Photos</span>
                        <span class="btn btn-pink" id="deleteAlbum"><i class="glyphicon glyphicon-trash"></i> Delete Album</span>

                        <form name="delete_photos" hidden action="DeletePhotoServlet" id="delete_photos">
                            <input type="text" hidden value="" name="photoLinks" id="photo_links">
                            <input type="text" hidden value=<%=albumID%> name="albumID">
                        </form>

                        <form name="delete_album" hidden action="DeleteAlbumServlet" id="delete_album">
                            <input type="text" hidden value=<%=albumID%> name="albumID">
                        </form>
                        <% } %>
                    </div>
                    <% }%>

                </div>

                <div id="displayPhotos" class="block-grid-lg-6 block-grid-md-5 block-grid-sm-4 block-grid-xs-2 thumbnail-row">
                    <% for (String photo : photoLinks) { %>
                    <div class="block-grid-item"><span class="zoom" onclick="clickedZoomIcon(this);"></span><img src=<%=photo%> class="img-responsive img-rounded lazy" onclick="clickedImage(this);" style="display: inline;"></div>
                    <% } %>
                </div>
            </div>
            <div class="scroll-div">Scroll to top <span class="glyphicon glyphicon-chevron-up"></span></div>
        </div>

<!-- Modal -->
<div id="zoomModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="zoomModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
            </div>
            <div class="modal-body">
                <img id="zoom-img" src="" class="img-responsive">
                <img class="leftico" src="assets/images/leftico.png" onclick="nextImage('left')">
                <img class="rightico" src="assets/images/rightico.png" onclick="nextImage('right')">
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="TagGroupAlbum" tabindex="-1" role="dialog" aria-labelledby="TagGroupsToAlbumModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h2 class="modal-title" id="TagGroupsToAlbumModalLabel">Share Album with Groups</h2>
            </div>
            <form name="tag_group" action="TagUsersServlet" method="get">
                <div class="modal-body">
                    <div class="form-group">
                        <input type="hidden" name="albumID" value='<%= albumID%>' id="tag_group_album_id"/>
                        <label for="groupNames">Which Groups(s) would you like to share this album with?</label>
                        <select id="groupNames" name="groups" class="selectpicker form-control"  multiple title='No Groups Selected' multiple>
                            <% HashMap<String, Group> groupMap = userController.getGroupMap();
                            for (String key : groupMap.keySet()) { %>
                            <option><%=key%></option>
                            <% }  %>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success pull-left addGroup" id="ajaxAddNewGroup" data-dismiss="modal">Add New Group</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-pink">Share Album</button>
                </div>
            </form>
        </div>
    </div>
</div>

                        
    <!-- Delete Modal confirmation -->
<div class="modal fade" id="deleteConfirmationModal" tabindex="-1" role="dialog" aria-labelledby="deleteGroupModallLabel" aria-hidden="true">
    <div class="modal-dialog modal-alert">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h2 class="modal-title" id="deleteGroupModallLabel">Delete Album</h4>
            </div>
            <div class="modal-body">
                <h4>Are you sure you want to delete this album?</h4>                               
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <input type="submit" class="btn btn-pink" onclick="deleteAlbum();" value="Delete Album"/>
            </div>
        </div>
    </div>
</div>
         
</div>

<%@include file="group_create.jsp"%> 
<script>
    
$(document).ready(function() {
  var id_counter = 1;  
  $("#displayPhotos .block-grid-item").each(function() {
        $(this).attr("id", "image" + id_counter);
        id_counter++;
  }); 
});
    
$('.selectpicker').selectpicker({
    style: 'btn-default',
    size: 4
});

$(".selectpicker").change(function() {
    $("#selected_albums").val(($(".selectpicker").val()));
});

$("#ajaxTagGroupAlbum").click(function() {
    $('#TagGroupAlbum').modal('show');
});

$("#removePhotos").click(function() {
    var photoLinks = "";
    var counter = 1;
    $(".imgSelected").each(function() {
        photoLinks += $(this).attr("src");
        if (counter != $(".imgSelected").length) {
            photoLinks += ",";
        }
        counter++;
    });
    photoLinks = photoLinks.toString();
    $("#photo_links").val(photoLinks);
    $("#delete_photos").submit();
});

$("#deleteAlbum").click(function() {
   $('#deleteConfirmationModal').modal('show');
});

function deleteAlbum(){
    $("#delete_album").submit();
};

function centerModal() {
    $(this).css('display', 'block');
    var $dialog = $(this).find(".modal-dialog");
    var offset = ($(window).height() - $dialog.height()) / 2;
    // Center modal vertically in window
    $dialog.css("margin-top", offset);
};
$('.modal').on('show.bs.modal', centerModal);
$(window).on("resize", function() {
    $('.modal:visible').each(centerModal);
});

$('#zoomModal').on('hidden.bs.modal', function(e) {
    $('#zoom-img').attr('src', "");
});

function clickedZoom(element) {
    var imgSrc = $(element).parent().find("img").attr("src");
    $('#zoom-img').attr('src', imgSrc);
    $('#zoomModal').modal('show');
};

function toggleRemove() {
    if ($('#displayPhotos img.imgSelected').length) {
        $('#removePhotos').removeClass("hidden");
        $('#deleteAlbum').addClass("hidden");
        $('#ajaxTagGroupAlbum').addClass("hidden");
        $('#downloadAlbum').addClass("hidden");

    } else {
        $('#removePhotos').addClass("hidden");
        $('#deleteAlbum').removeClass("hidden");
        $('#ajaxTagGroupAlbum').removeClass("hidden");
        $('#downloadAlbum').removeClass("hidden");
    }
};

function clickedImage(element) {
    var istaggedAlbum = document.getElementById("taggedAlbumhidden"); 
    if(istaggedAlbum == null){
        $(element).toggleClass("imgSelected");
        toggleRemove();
    }
};

var goTop = true;
$(".scroll-div").click(function() {
    var heightTo = 0;
    if (!goTop)
        heightTo = $(document).height();

    $('html, body').animate({scrollTop: heightTo}, 500, function() {
        if (goTop)
            $(".scroll-div").fadeOut();
    });
});

$(window).scroll(function() {
    var windowHeight = $(window).height();
    var y = $(window).scrollTop() + windowHeight;
    var halfWindow = windowHeight / 2;
    var isAnimating = $(".scroll-div").is(':animated');

    if (!isAnimating) {
        if ((windowHeight + halfWindow) > y)
            $(".scroll-div").fadeOut();
        else
            $(".scroll-div").fadeIn();
    }
});

function clickedZoomIcon(element) {
    var imgSrc = $(element).parent().find("img").attr("src");
    var imageID = $(element).closest(".block-grid-item").attr("id");
    $('#zoom-img').attr('src', imgSrc);
    $('#zoom-img').attr('imageid', imageID);
    $('#zoomModal').modal('show');
    event.stopPropagation();
};

$('body').keyup(function(event) {
    if ($("#zoomModal").hasClass("in")){
        if (event.keyCode === 37){
           var incomingID = $("#zoom-img").attr("imageid");
           var id = incomingID.substring(5);
           showNextImage(id, "left");
        }  else if (event.keyCode === 39){
           var incomingID = $("#zoom-img").attr("imageid");
           var id = incomingID.substring(5);
           showNextImage(id, "right");
        }
    }
});

function showNextImage(currentID, direction){
    var max = $("#displayPhotos > .block-grid-item").length;
    if (currentID >= 1 && currentID <= max){
        if (direction == "left"){
            if (currentID != 1){
                var leftID = currentID - 1;
                var imgSrc = $("#image" + leftID).children("img").attr("src");
                var imageID = "image" + leftID;
                $('#zoom-img').attr('src', imgSrc);
                $('#zoom-img').attr('imageid', imageID);
            }
        } else {
            if (currentID != max){
                var rightID = parseInt(currentID) + 1;
                var imgSrc = $("#image" + rightID).children("img").attr("src");
                var imageID = "image" + rightID;
                $('#zoom-img').attr('src', imgSrc);
                $('#zoom-img').attr('imageid', imageID);
            }
        }
    } 
};

function nextImage(direction){
    var incomingID = $("#zoom-img").attr("imageid");
    var id = incomingID.substring(5);
    showNextImage(id, direction);
};


</script>
</body>
</html>