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

</head>
<body>
    <%
    session.setAttribute("location", "albums");
    String albumID = request.getParameter("id");
    Album album = AlbumController.getAlbumByID(albumID);
    String albumName = album.getName();
    %>
    <div class="container-fluid">
        <div class="row">
            <%@include file="sidebar.jsp"%> 
            <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">

                <h1 class="page-header"><a class="backAnchor" href="albums.jsp"><i class="glyphicon glyphicon-chevron-left"></i></a> #<%=albumName%></h1>
                <% if (session.getAttribute("success") != null) {%>
                <div class="alert alert-success">  
                    <a class="close" data-dismiss="alert">×</a>  
                    <strong><%=session.getAttribute("success")%></strong>  
                </div> 
                <% session.removeAttribute("success");
            }%>

            <% if (session.getAttribute("error") != null) {%>
            <div class="alert alert-danger">  
                <a class="close" data-dismiss="alert">×</a>  
                <strong><%=session.getAttribute("error")%></strong>  
            </div> 
            <% session.removeAttribute("error");
        }%>

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
                    <input type="text" hidden value=<%=albumID%> name="albumID">
                </form>
            </div>


            <% } else {%>

            <% boolean isTaggedAlbum =  album.getOwner() != UserController.getUserLoggedIn(); %>

            <% ArrayList<User> taggedUsers = album.getTaggedUsers(); 
            if(!taggedUsers.isEmpty()){%>
            <div class="col-sm-7">       
                <p class="taggedMembers">

                    <% if(!isTaggedAlbum){ %>
                    Tagged Users: 
                    <% for (int i = 0; i < taggedUsers.size(); i++) { %>
                    <% User taggedUser = taggedUsers.get(i); %>
                    <span class="label label-default"><%= taggedUser.getUsername() %></span>
                    <% } %>
                    <% }else{ %>
                    You have been tagged in this album by <%= album.getOwner() %>!
                    <input type="hidden" id="taggedAlbumhidden" value="true">
                    <% } %>
                </p>
            </div>

            <% } %>

            <div class="col-sm-5 text-right pull-right">

                <span class="btn btn-default" onclick="download();"><i class="glyphicon glyphicon-download-alt" ></i> Download</span>

                <input type="hidden" id="imagelinks" name ="imagelinks" value='<%=photoLinks.toString()%>'/>
                
                <% if(!isTaggedAlbum){ %>
                <span class="btn btn-info" id="ajaxTagGroupAlbum"><i class="glyphicon glyphicon-tag"></i>Tag Group</span>
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
            <div class="block-grid-item"><span class="zoom" onclick="clickedZoom(this);"></span><img src=<%=photo%> class="img-responsive img-rounded lazy" onclick="clickedImage(this);" style="display: inline;"></div>
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
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="TagGroupAlbum" tabindex="-1" role="dialog" aria-labelledby="TagGroupsToAlbumModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h2 class="modal-title" id="TagGroupsToAlbumModalLabel">Tag Groups to this Album</h2>
            </div>
            <form name="tag_group" action="TagUsersServlet" method="get">
                <div class="modal-body">
                    <div class="form-group">
                        <input type="hidden" name="albumID" value='<%= albumID%>' id="tag_group_album_id"/>
                        <label for="groupName">Which Groups(s) would you like to tag this album to?</label>
                        <select id="groupName" name="groups" class="selectpicker form-control"  multiple title='No Groups Selected' multiple>
                            <% HashMap<String, Group> groupMap = UserController.getGroupMap();
                            for (String key : groupMap.keySet()) { %>
                            <option><%=key%></option>
                            <% }  %>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success pull-left" id="ajaxAddNewGroup" data-dismiss="modal">Add New Group</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-pink">Tag Groups</button>
                </div>
            </form>
        </div>
    </div>
</div>


<div class="modal fade" id="addNewGroupModal" tabindex="-1" role="dialog" aria-labelledby="addNewGroupModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h2 class="modal-title" id="myModalLabel">Create a new group</h4>
                </div>
                <form id="addGroupForm" class="form-horizontal" action="AddGroupServlet">
                    <div class="modal-body">

                        <div class="form-group">
                            <label for="groupName" class="col-sm-3 control-label">Group Name</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="groupName" name="groupName" autocomplete="off"  required placeholder="Enter a name for your new album"/>
                                <input type="hidden" name="processedGroupMembers" id="processedGroupMembers" />
                                <input type="hidden" name="albumID" id="add_new_group_albumID" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="groupMembers" class="col-sm-3 control-label">Group Members</label>
                            <div class="col-sm-9">
                                <div data-tags-input-name="tag" class="form-control" id="groupMembers"></div>
                            </div>

                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-pink" onclick="addGroup();">Create Group</button>
                    </div>
                </form>
            </div>
        </div>
    </div>


</div>


<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="assets/js/bootstrap.min.js"></script>
<script src="assets/js/bootstrap-select.js"></script>
<script src="assets/js/jquery.lazyload.min.js" type="text/javascript"></script>
<script src="assets/js/tagging.min.js"></script>


<script type="text/javascript">
$(document).ready(function() {
    var my_custom_options = {
        "no-duplicate": true,
        "no-duplicate-callback": window.alert,
        "no-duplicate-text": "Duplicate tags",
        "forbidden-chars": [",", "?","!","$","%","^","&","*"],
        "edit-on-delete": false
    };
    $('#groupMembers').tagging(my_custom_options);
    $('#editGroupMembers').tagging(my_custom_options);
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
    $('#selected_photos').val(ids);
});

$("#ajaxAddNewGroup").click(function() {
 $('#groupMembers').tagging("reset");
 $('#addNewGroupModal').modal('show');
 $('#add_new_group_albumID').val($('#tag_group_album_id').val());
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
    $("#delete_album").submit();
});

function addGroup() {
    $("#processedGroupMembers").val($('#groupMembers').tagging("getTags"));
    $("#addGroupForm").submit();
}

function centerModal() {
    $(this).css('display', 'block');
    var $dialog = $(this).find(".modal-dialog");
    var offset = ($(window).height() - $dialog.height()) / 2;
    // Center modal vertically in window
    $dialog.css("margin-top", offset);
}
$('.modal').on('show.bs.modal', centerModal);
$(window).on("resize", function() {
    $('.modal:visible').each(centerModal);
});

$('#zoomModal').on('hidden.bs.modal', function(e) {
    $('#zoom-img').attr('src', "");
})

function clickedZoom(element) {
    var imgSrc = $(element).parent().find("img").attr("src");
    $('#zoom-img').attr('src', imgSrc);
    $('#zoomModal').modal('show');
};

function toggleRemove() {
    if ($('#displayPhotos img.imgSelected').length) {
        $('#removePhotos').removeClass("hidden");
        $('#deleteAlbum').addClass("hidden");

    } else {
        $('#removePhotos').addClass("hidden");
        $('#deleteAlbum').removeClass("hidden");
    }
};

function clickedImage(element) {
    var istaggedAlbum = document.getElementById("taggedAlbumhidden"); 
    if(istaggedAlbum == null){
        $(element).toggleClass("imgSelected");
        toggleRemove();
    }
};

function download() {
    var imagelink = document.getElementById("imagelinks");
    $.ajax({
        type: "POST",
        url: "DownloadServlet",
        data: ({
            imagelink: imagelink.value
        }),
        success: function(data, textstatus, jqXHR) {
        }
    });
}

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


</script>
</body>
</html>