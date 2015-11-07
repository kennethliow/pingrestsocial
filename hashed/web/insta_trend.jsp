<%@page import="controllers.UserController"%>
<%@page import="models.Album"%>
<%@page import="controllers.AlbumController"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <jsp:include page="album_create.jsp"/> 
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <link rel="icon" href="../../favicon.ico">

        <title>Instagram Crawler</title>

        <!-- Bootstrap core CSS -->
        <link href="assets/css/bootstrap.min.css" rel="stylesheet">

        <!-- Custom styles for this template -->
        <link href="assets/css/hashed.css" rel="stylesheet">
        <link href="assets/css/blockgrid.css" rel="stylesheet">
        <link href="assets/css/bootstrap-select.css" rel="stylesheet">
        <link href="assets/css/bootstrap-select.min.css" rel="stylesheet">
        <style>
        #map {
          height: 300px;
        }
        </style>
    </head>
    <body>

        <% session.setAttribute("location", "explore");%>

        <div class="container-fluid">
            <div class="row">

                <%@include file="sidebar.jsp"%> 

                <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
                    <h1 class="page-header">Trending Around Ping's</h1>

                    <% if (session.getAttribute("error") != null) {%>
                    <div class="alert alert-danger">  
                        <a class="close" data-dismiss="alert">×</a>  
                        <strong><%=session.getAttribute("error")%></strong>  
                    </div> 
                    <% session.removeAttribute("error");}%>

                    <div class="row">

                        <div id="searchDiv" class="col-md-12 col-lg-12 center-text">
                            <form id="searchForm">
                                <b>Ping's Restaurant Outlet At:&nbsp;&nbsp; </b>
                                <div class="btn-group">
                                    <button class="btn btn-default" id="abut">Please Select From List</button>
                                    <button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                                        <span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu">
                                        <li class="a"><a tabindex="-1" href="#">Pathumwan Princess Hotel</a></li>
                                        <li class="a"><a tabindex="-1" href="#">Sukhumvit 21</a></li>
                                        <li class="divider"></li>
                                        <li class="a"><a tabindex="-1" href="#">Other</a></li>
                                    </ul>
                                </div>
                                
                                <b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Radius:&nbsp;&nbsp; </b>
                                <div class="btn-group">
                                    <button class="btn btn-default" id="bbut">Please Select From List</button>
                                    <button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                                        <span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu">
                                        <li class="b"><a tabindex="-1" href="#">500m</a></li>
                                        <li class="b"><a tabindex="-1" href="#">1km</a></li>
                                        <li class="b"><a tabindex="-1" href="#">2km</a></li>
                                    </ul>
                                </div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <div class="btn-group"><button type="button" class="btn btn-primary" style="padding: 5px 50px;font-weight:bold;" id="crawl">Crawl Instagram</button></div>
                            </form>
                            <hr>
                        </div>

                        <div id="addDiv" class="col-sm-2 hidden">
                            <h2 id="addDivOffset"></h2>
                            <button type="button" class="btn btn-pink btn" id="ajaxAddToAlbum">Add to Album</button>
                        </div>

                    </div>

                    <div class="row">
                        <div class="col-md-12 col-lg-12 center-text">
                            <div id="map"></div>
                            <hr>
                        </div>
                    </div>
                    
                    <div id="displayPhotos" class="block-grid-lg-6 block-grid-md-5 block-grid-sm-4 block-grid-xs-2 thumbnail-row"></div>

                </div><!-- End of main -->

            </div><!-- End of row -->
            <a id="back-to-top" href="#" class="btn btn-pink btn-lg back-to-top" role="button" title="Click to return on the top page" data-toggle="tooltip" data-placement="left"><span class="glyphicon glyphicon-chevron-up"></span></a>


            <div id="loading" class="hidden">
                <h2>Fetching Photos..</h2>
            </div>

        </div> <!-- End of container -->



        <!-- Zoom Modal -->
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


        <!-- Add to Album Modal -->
        <div class="modal fade" id="addToAlbum" tabindex="-1" role="dialog" aria-labelledby="AddtoAlbumModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                        <h2 class="modal-title" id="AddtoAlbumModalLabel">Add Photos to Album</h4>
                    </div>

                    <form name="add_to_album" action="AddPhotoServlet" method="get">
                        <div class="modal-body">

                            <div class="form-group">
                                <label for="albumName">Which album(s) would you like to add these photos to?</label>
                            </div>
                            <input type="hidden" id="selected_photos" name="photoIDs" value=""/>
                            <input type="hidden" id="selected_photos_links" name="photoLinks" value=""/>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-success pull-left" id="ajaxAddNewAlbum" data-dismiss="modal">Add New Album</button>
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-pink">Add Photos</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>


        <div class="modal fade" id="errorModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-alert">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>

                    </div>
                    <form class="form-horizontal" action="LogoutServlet">
                        <div class="modal-body">
                            <h4 class="center-text">Oops! This is a private user.</h4>

                            <div class="modalbuttonsDiv center-text">
                                <button type="button" class="btn btn-pink" data-dismiss="modal">OK</button>
                            </div>
                    </form>
                </div>
            </div>
        </div>


        <!-- Bootstrap core JavaScript
        ================================================== -->
        <!-- Placed at the end of the document so the pages load faster -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script> 
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/bootstrap-select.min.js"></script>
        <script src="assets/js/jquery.lazyload.min.js" type="text/javascript"></script>
        <script src="assets/js/spin.min.js" type="text/javascript"></script>
        <script src="assets/js/bloxhover.jquery.min.js" type="text/javascript"></script>
        <script>
        function initMap() {
            var aLatLng = {lat: 13.742989443, lng: 100.529936132};
            var bLatLng = {lat: 13.740318, lng: 100.561748};
            var map = new google.maps.Map(document.getElementById('map'), {
                zoom: 15,
                center: {lat: 13.742989443, lng: 100.529936132}
            });
            var aMarker = new google.maps.Marker({
                position: aLatLng,
                map: map,
                title: 'Pathumwan Princess Hotel'
            });
            var bMarker = new google.maps.Marker({
                position: aLatLng,
                map: map,
                title: 'Sukhumvit 21'
            });
        }
        </script>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDfZUauOgeobVplylSM87ASk8R1oD2OqCo&signed_in=true&callback=initMap" async defer></script>
        <script>
var lat = 13.742989443;
var lng = 100.529936132;
var dist = 500;
            
//Document Ready
$(document).ready(function() {
    $(".a").click(function(){
        var aVal = $(this).text();
        if(aVal==="Pathumwan Princess Hotel"){
            lat = 13.742989443;
            lng = 100.529936132;
        } else if (aVal==="Sukhumvit 21") {
            lat = 13.740318;
            lng = 100.561748;
        }
        $("#abut").text(aVal);
        $("#abut").val(aVal);
    });
    $(".b").click(function(){
        var bVal = $(this).text();
        if(bVal==="500m"){
            dist = 500;
        } else if (bVal==="1km") {
            dist = 1000;
        } else if (bVal==="2km") {
            dist = 2000;
        }
        $("#bbut").text(bVal);
        $("#bbut").val(bVal);
    });
    $("#crawl").click(function(){
        displayPopular();
    });
});

$(window).scroll(function() {
    if ($(this).scrollTop() > 50) {
        $('#back-to-top').fadeIn();
    } else {
        $('#back-to-top').fadeOut();
    }
});
// scroll body to 0px on click
$('#back-to-top').click(function() {
    $('#back-to-top').tooltip('hide');
    $('body,html').animate({
        scrollTop: 0
    }, 800);
    return false;
});

$('#back-to-top').tooltip('show');
var span_counter = $("#searchHeader span").length + 1;
var image_counter = 1;

//updateSearchHeader
function updateSearchHeader(isUser, searchText) {
    var sym = '#';

    if (isUser == true) {
        sym = '@';
    }

    if ($("#searchHeader").text() == "") {
        $("#searchHeader").html("&nbsp;");
        span_counter = 1;
    }
    if ($("#searchText").val().length > 0) {
        var existText = $("#searchHeader").html();
        if (existText === "&nbsp;") {
            $("#searchHeader").html("<span onclick='removeTag(this.id);' class='searchTags' id='" + span_counter + "'>"
                    + sym + "" + searchText + "<img class='actionDelete' src='assets/images/delico.png'></span>");
            span_counter++;
        } else {
            $("#searchHeader").html(existText + "<span class='searchTagsPlus' id='" + span_counter + "'> + </span>" + "<span onclick='removeTag(this.id);' class='searchTags' id='" + (span_counter + 1) + "'>" + sym + "" + searchText + "<img class='actionDelete' src='assets/images/delico.png'></span>");
            span_counter += 2;
        }
    }
    $("#searchText").val("");
    span_counter = $("#searchHeader span").length + 1;
}


//AJAX for Popular
function displayPopular() {
    span_counter = 1;
    image_counter = 1;

    var access_token = '<%= session.getAttribute("access_token")%>';
    window.name = "popular";
    $.ajax({
        type: "POST",
        dataType: "jsonp",
//        url: "https://api.instagram.com/v1/media/popular?access_token=" + access_token,
        url: "https://api.instagram.com/v1/media/search?lat=" + lat + "&lng=" + lng + "&distance=" + dist + "&access_token=454859018.89c8fdb.145d2bd0d74b4e0da0893a5cab992523",
        success: function(data) {
            var preparedHtml = '';
            var results_array = (data["data"]);
            var photolimit = 0;

            $.each(results_array, function(key, element) {
                if (element["type"] == "image") {
                    photolimit++;
                    if (photolimit < 13) {
                        preparedHtml = preparedHtml + '<div class="block-grid-item" id="image' + image_counter + '"><div onclick="clickedOverlay(this);" class="overlayBox"><img src="' + element["images"]["standard_resolution"]["url"] + '" ref="' + element["images"]["standard_resolution"]["url"] + '" mediaid="' + element["id"] + '" class="img-responsive img-rounded"/><div><img class="actionZoom" onclick="clickedZoomIcon(this);" src="assets/images/zoomico.png" style="margin-right: 20px;"/><img class="actionAdd" onclick="clickedAddIcon(this);" src="assets/images/add2ico.png"/></a></div></div></div>';
                        image_counter++;
                    }
                }
            });

            document.getElementById("displayPhotos").innerHTML = preparedHtml + document.getElementById("displayPhotos").innerHTML;
            $('.overlayBox').bloxhover({effect: 'square', duration: 500, sliceCount: 9, delay: 20});
            $("img.lazy").show().lazyload();

        },
        error: function(jqXHR, textStatus, errorThrown) {
            alert(textStatus + errorThrown);
        }
    });
}

function searchPhotos2(search_field){
    $('#welcomeslide').addClass("hidden");
    $("#addDivOffset").html("&nbsp;");
    
    var opts = {
        lines: 14, // The number of lines to draw
        length: 26, // The length of each line
        width: 10, // The line thickness
        radius: 35, // The radius of the inner circle
        corners: 1, // Corner roundness (0..1)
        rotate: 0, // The rotation offset
        direction: 1, // 1: clockwise, -1: counterclockwise
        color: '#fff', // #rgb or #rrggbb or array of colors
        speed: 1.8, // Rounds per second
        trail: 60, // Afterglow percentage
        shadow: false, // Whether to render a shadow
        hwaccel: false, // Whether to use hardware acceleration
        className: 'spinner', // The CSS class to assign to the spinner
        zIndex: 2e9, // The z-index (defaults to 2000000000)
        top: '58%', // Top position relative to parent
        left: '58%' // Left position relative to parent
    };
    var target = document.getElementById('loading');
    $('#loading').removeClass("hidden");
    var spinner = new Spinner(opts).spin(target);
    
    if (searchVal == "") {
        searchVal = search_field;
    }

    var isUser = false;

    var first = searchVal.charAt(0);
    if (/^[a-zA-Z0-9- ]*$/.test(first) == false) {
        searchVal = searchVal.substring(1);
        if (first == '#') {
            isUser = false;
        } else if (first == '@') {
            isUser = true;
        }
    }
    
    updateSearchHeader(isUser, searchVal);
    
    if (!isUser){
        $.ajax({
            type: "POST",
            dataType: "json",
            url: "/ImageSearchServlet?search_term=" + search_field,
            success: function(data) {
                var preparedHtml = '';
                $.each(data, function(key, element) {
                    if (element["type"] == "image") {
                        preparedHtml = preparedHtml + '<div class="block-grid-item search-' + searchVal + '"><div onclick="clickedOverlay(this);" class="overlayBox"><img src="' + element["image_link"] + '" ref="' + element["image_link"] + '"mediaid="' + element["id"] + '" class="img-responsive img-rounded"/><div><img class="actionZoom" onclick="clickedZoomIcon(this);" src="assets/images/zoomico.png" style="margin-right: 20px;"/><img class="actionAdd" onclick="clickedAddIcon(this);" src="assets/images/add2ico.png"/></a></div></div></div>';
                    }
                });
                
                document.getElementById("displayPhotos").innerHTML = preparedHtml + document.getElementById("displayPhotos").innerHTML;

                $("img.lazy").show().lazyload();
                $('.overlayBox').bloxhover({effect: 'square', duration: 500, sliceCount: 9, delay: 20});

                $('#loading').addClass("hidden");
                spinner.stop();
                $('#searchText').prop("disabled", false);
                $('#searchText').focus();
                updateImageID();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                alert(textStatus + errorThrown);
            }
        });  
    }
};

//AJAX for SearchPhotos
function searchPhotos(next_url, run, searchHtml, searchField, spinner) {  
    if (run == null) {
        $('#welcomeslide').addClass("hidden");
        $("#addDivOffset").html("&nbsp;");

        searchHtml = "";
        run = 1;

        var opts = {
            lines: 14, // The number of lines to draw
            length: 26, // The length of each line
            width: 10, // The line thickness
            radius: 35, // The radius of the inner circle
            corners: 1, // Corner roundness (0..1)
            rotate: 0, // The rotation offset
            direction: 1, // 1: clockwise, -1: counterclockwise
            color: '#fff', // #rgb or #rrggbb or array of colors
            speed: 1.8, // Rounds per second
            trail: 60, // Afterglow percentage
            shadow: false, // Whether to render a shadow
            hwaccel: false, // Whether to use hardware acceleration
            className: 'spinner', // The CSS class to assign to the spinner
            zIndex: 2e9, // The z-index (defaults to 2000000000)
            top: '58%', // Top position relative to parent
            left: '58%' // Left position relative to parent
        };
        var target = document.getElementById('loading');

        $('#loading').removeClass("hidden");
        spinner = new Spinner(opts).spin(target);
    }
    
    // success callback
    if (run == 5) {
        document.getElementById("displayPhotos").innerHTML = searchHtml + document.getElementById("displayPhotos").innerHTML;

        $("img.lazy").show().lazyload();
        $('.overlayBox').bloxhover({effect: 'square', duration: 500, sliceCount: 9, delay: 20});

        $('#loading').addClass("hidden");
        spinner.stop();
        $('#searchText').prop("disabled", false);
        $('#searchText').focus();
        updateImageID();
        return false;
    }

    var searchVal = $("#searchText").val();
    $("#searchText").attr("placeholder", "Search");

    if (searchVal == "") {
        searchVal = searchField;
    }

    var isUser = false;

    var first = searchVal.charAt(0);
    if (/^[a-zA-Z0-9- ]*$/.test(first) == false) {
        searchVal = searchVal.substring(1);
        if (first == '#') {
            isUser = false;
        } else if (first == '@') {
            isUser = true;
        }
    }

    updateSearchHeader(isUser, searchVal);
    var access_token = '<%= session.getAttribute("access_token")%>';


    if (!isUser) {

        var calling_url = "https://api.instagram.com/v1/tags/" + searchVal + "/media/recent?access_token=" + access_token;
        if (next_url != null) {
            calling_url = next_url;
        }
        $.ajax({
            type: "POST",
            dataType: "jsonp",
            url: calling_url,
            success: function(data) {
                var preparedHtml = '';
                var results_array = (data["data"]);
                $.each(results_array, function(key, element) {
                    if (element["type"] == "image") {
                        preparedHtml = preparedHtml + '<div class="block-grid-item search-' + searchVal + '"><div onclick="clickedOverlay(this);" class="overlayBox"><img src="' + element["images"]["standard_resolution"]["url"] + '" ref="' + element["images"]["standard_resolution"]["url"] + '"mediaid="' + element["id"] + '" class="img-responsive img-rounded"/><div><img class="actionZoom" onclick="clickedZoomIcon(this);" src="assets/images/zoomico.png" style="margin-right: 20px;"/><img class="actionAdd" onclick="clickedAddIcon(this);" src="assets/images/add2ico.png"/></a></div></div></div>';
                    }
                });
                run++;
                searchHtml = preparedHtml + searchHtml;
                searchPhotos(data["pagination"]["next_url"], run, searchHtml, searchVal, spinner);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                alert(textStatus + errorThrown);
            }
        });
    } else {

        var userId = '';

        var calling_url = "https://api.instagram.com/v1/users/search?q=" + searchVal + "&access_token=" + access_token;
        $.ajax({
            type: "POST",
            dataType: "jsonp",
            url: calling_url,
            success: function(data) {
                userId = data["data"][0]["id"];
                user_media_search(userId);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                alert(textStatus + errorThrown);
            }
        });


        function user_media_search(userId) {
            var calling_url = "https://api.instagram.com/v1/users/" + userId + "/media/recent/?access_token=" + access_token;
            if (next_url != null) {
                calling_url = next_url;
            }
            $.ajax({
                type: "POST",
                dataType: "jsonp",
                url: calling_url,
                success: function(data) {
                    if (data["data"]) {
                        var preparedHtml = '';
                        var results_array = (data["data"]);
                        $.each(results_array, function(key, element) {
                            if (element["type"] == "image") {
                                preparedHtml = preparedHtml + '<div class="block-grid-item search-' + searchVal + '"><div onclick="clickedOverlay(this);" class="overlayBox"><img src="' + element["images"]["standard_resolution"]["url"] + '" ref="' + element["images"]["standard_resolution"]["url"] + '" mediaid="' + element["id"] + '" class="img-responsive img-rounded"/><div><img class="actionZoom" onclick="clickedZoomIcon(this);" src="assets/images/zoomico.png" style="margin-right: 20px;"/><img class="actionAdd" onclick="clickedAddIcon(this);" src="assets/images/add2ico.png"/></a></div></div></div>';
                            }
                        });
                        run++;
                        searchHtml = preparedHtml + searchHtml;
                        searchPhotos(data["pagination"]["next_url"], run, searchHtml, "@" + searchVal, spinner);
                    } else {
                        $('#loading').addClass("hidden");
                        spinner.stop();
                        $('#errorModal').modal('show');
                        $("#searchHeader").html("Please try searching again");
                        displayPopular();
                        $('#searchText').prop("disabled", false);
                        return false;
                    }

                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }


    }
}



//Space / Enter
$("#searchText").keypress(function(event) {
    if (event.keyCode == 32 || event.keyCode == 13) {
        if (window.name == "popular") {
            clearResults();
        }
        if ($("#searchText").val().trim() != "") {
            $('#searchText').prop("disabled", true);
            window.name = "search";
            searchPhotos();
        }
        event.preventDefault();
    }
});

//Handles Search Form
$("#searchForm").submit(function(event) {
    if (window.name == "popular") {
        clearResults();
    }
    if ($("#searchText").val().trim() != "") {
        $('#searchText').prop("disabled", true);
        window.name = "search";
        searchPhotos();
    }
    event.preventDefault();
});

//clearResults
function clearResults() {
    document.getElementById("displayPhotos").innerHTML = "";
}
;

//SelectPicker for groups
$('.selectpicker').selectpicker({
    style: 'btn-default',
    size: 4
});

//Get id of Photos
$("#ajaxAddToAlbum").click(function() {
    var ids = '';
    var links = '';

    $(".imgSelected").each(function() {
        if (ids.length != 0) {
            ids = ids + ',';
        }
        if (links.length != 0) {
            links = links + ',';
        }
        var retrieved_media_id = $(this).attr('mediaid');
        var retrieved_media_link = $(this).attr('ref');
        ids = ids + retrieved_media_id;
        links = links + retrieved_media_link;
    });

    $('#addToAlbum').modal('show');
    $('#selected_photos').val(ids);
    $('#selected_photos_links').val(links);
    $('#selected_photos_new_album').val(ids);
    $('#selected_photos_links_new_album').val(links);
});

//Handle add new album button
$("#ajaxAddNewAlbum").click(function() {
    $('#add_new_album').modal('show');
});


//Remove tag function
function removeTag(id) {
    $('.searchTags').each(function() {
        var search_delete = ($("#" + id).text().substring(1));
        if (id != 1) {
            $("#" + (id - 1)).addClass("to_be_removed");
        } else {
            $("#2").addClass("to_be_removed");
        }
        if (this.id === id) {
            $(this).addClass("to_be_removed");
        }
        $('.to_be_removed').remove();
        $('.search-' + search_delete).remove();
    });

    if ($("#searchHeader").text() == "") {
        $("#searchHeader").html("&nbsp;");
        displayPopular();
    }

    updateSpanID();
    updateImageID();

}
;

//update span ID
function updateSpanID() {
    var id_counter = 1;
    $("#searchHeader span").each(function() {
        $(this).attr("id", id_counter);
        id_counter++;
    });
    span_counter = $("#searchHeader span").length + 1;
}
;

//Remove img on zoom out.
$('#zoomModal').on('hidden.bs.modal', function(e) {
    $('#zoom-img').attr('src', "");
})

//update image ID
function updateImageID(){
  var id_counter = 1;  
  $("#displayPhotos .block-grid-item").each(function() {
        $(this).attr("id", "image" + id_counter);
        id_counter++;
  });
};


function clickedZoom(element) {
    var imgSrc = $(element).parent().find("img").attr("src");
    $('#zoom-img').attr('src', imgSrc);
    $('#zoomModal').modal('show');
}
;

function strinkSearchDiv() {
    if ($('#displayPhotos img.imgSelected').length) {
        $('#searchDiv').removeClass("col-sm-8").addClass("col-sm-7");
        $('#addDiv').removeClass("hidden");
    } else {
        $('#searchDiv').removeClass("col-sm-7").addClass("col-sm-8");
        $('#addDiv').addClass("hidden");
    }
}
;

function clickedImage(element) {
    /* $(element).toggleClass("imgSelected");
    strinkSearchDiv(); */
}

function clickedZoomIcon(element) {
    var imgSrc = $(element).closest(".overlayBox").children(".img-rounded").attr("src");
    var imageID = $(element).closest(".block-grid-item").attr("id");
    $('#zoom-img').attr('src', imgSrc);
    $('#zoom-img').attr('imageid', imageID);
    $('#zoomModal').modal('show');
    event.stopPropagation();
};


function clickedAddIcon(element) {
    var imgSrc = $(element).attr("src");
    if (imgSrc.indexOf("remove") != -1) {
        $(element).attr('src', "assets/images/add2ico.png");
    } else {
        $(element).attr('src', "assets/images/remove2ico.png");
    }
    $(element).closest(".overlayBox").toggleClass("boxSelected");
    $(element).closest(".overlayBox").children(".img-rounded").toggleClass("imgSelected");
    strinkSearchDiv();
    event.stopPropagation();
}
;


function clickedOverlay(element) {
    /*
    var imgSrc = $(element).find(".actionAdd").attr("src");
    if (imgSrc.indexOf("remove") != -1) {
        $(element).find(".actionAdd").attr('src', "assets/images/add2ico.png");
    } else {
        $(element).find(".actionAdd").attr('src', "assets/images/remove2ico.png");
    }
    $(element).toggleClass("boxSelected");
    $(element).children(".img-rounded").toggleClass("imgSelected");
    strinkSearchDiv();
    event.stopPropagation();
    */
};

//keypress listener on zoom modal
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
                var imgSrc = $("#image" + leftID).children(".overlayBox").children(".img-rounded").attr("src");
                var imageID = "image" + leftID;
                $('#zoom-img').attr('src', imgSrc);
                $('#zoom-img').attr('imageid', imageID);
            }
        } else {
            if (currentID != max){
                var rightID = parseInt(currentID) + 1;
                var imgSrc = $("#image" + rightID).children(".overlayBox").children(".img-rounded").attr("src");
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
