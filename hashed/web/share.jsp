<%@page import="models.User"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="org.parse4j.ParseQuery"%>
<%@page import="org.parse4j.ParseObject"%>
<%@page import="org.parse4j.Parse"%>
<%@page import="models.Album"%>
<%@page import="java.util.ArrayList"%>
<%@page import="controllers.AlbumController"%>
<!DOCTYPE html>
<html lang="en">
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
        <link href="assets/css/bootstrap-select.css" rel="stylesheet">
        <link href="assets/css/bootstrap-select.min.css" rel="stylesheet">

        <script src="assets/js/ie-emulation-modes-warning.js"></script>
    </head>
        <%String currentURL = request.getRequestURL().toString();
        String loginURL = "";
        if (currentURL.indexOf("localhost") != -1) {
            session.setAttribute("environment", "development");
            loginURL = "https://api.instagram.com/oauth/authorize/?client_id=ae09aaad138048e9a144317336a003f7&redirect_uri=http://localhost:8084/hashed/LoginServlet&response_type=code";
        } else {
            session.setAttribute("environment", "staging");
            loginURL = "https://api.instagram.com/oauth/authorize/?client_id=bb635ec0a55d4a8e8c24b858e6e60a75&redirect_uri=http://hashed-g2t9.rhcloud.com/LoginServlet&response_type=code";
        }
        String albumID = request.getParameter("id");
        String groupID = request.getParameter("groupID");
        String code = request.getParameter("code");
        Parse.initialize("P0CrqeHC9sOY0qNzO1Gl9NZfbVPlIGSvhvAc4c9N", "pors7XxI3oWEHwARoKLkXJmROmFZorbq8zL5cuyH");
        ParseQuery<ParseObject> query = ParseQuery.getQuery("Album");
        query.whereEqualTo("objectId", albumID);
        List<ParseObject> albumRetrieved = query.find();
        String albumName = "";
        ArrayList<String> photoLinks = new ArrayList<String>();
        if (albumRetrieved != null) {
            ParseObject album = query.find().get(0);
            albumName = album.getString("albumname");
            String retrieved_photo_links = album.getString("photolinks");
            if (retrieved_photo_links.isEmpty()) {
                photoLinks = new ArrayList<String>();
            } else {
                photoLinks = new ArrayList<String>(Arrays.asList(retrieved_photo_links.split(",")));
            }
            String taggedUsersString = album.getString("tagged_users");
            ArrayList<String> taggedUsers = new ArrayList<String>();
            if (!taggedUsersString.isEmpty()) {
                taggedUsers = new ArrayList<String>(Arrays.asList(taggedUsersString.split(",")));
            }
            session.setAttribute("newAlbumID", albumID);
            session.setAttribute("newGroupID", groupID);
            session.setAttribute("verificationCode", code);%>
    <body>
        <div class="container-fluid">
            <div class="row">

                <div class="col-md-10 col-md-offset-1 main">
                    <h1 class="page-header"><%=albumName%></h1>

                    <div class="row">

                        <div class="col-sm-3 text-right pull-right">
                            <a href=<%=loginURL%>><img class="img-responsive sign-in" src="assets/images/signin-btn.png"></a>
                        </div>
                    </div>

                    <div id="displayPhotos" class="block-grid-lg-6 block-grid-md-5 block-grid-sm-4 block-grid-xs-2 thumbnail-row">
                        <% for (String photo : photoLinks) {%>
                        <div class="block-grid-item"><span class="zoom" onclick="clickedZoom(this);"></span><img src=<%=photo%> class="img-responsive img-rounded lazy" onclick="clickedImage(this);" style="display: inline;"></div>
                            <%}%>
                    </div>

                </div>

            </div>

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


        <!-- Bootstrap core JavaScript
        ================================================== -->
        <!-- Placed at the end of the document so the pages load faster -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/docs.min.js"></script>
        <script src="assets/js/bootstrap-select.js"></script>
        <script src="assets/js/bootstrap-select.min.js"></script>
        <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
        <script src="assets/js/ie10-viewport-bug-workaround.js"></script>
        <script src="assets/js/jquery.lazyload.min.js" type="text/javascript"></script>

        <script>
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
                            }
                            ;

        </script>
    </body>
    <%} else {%>
    <body>
        <div class="container-fluid">
            <div class="row">

                <div class="col-md-10 col-md-offset-1 main">
                    <h1 class="page-header"><%=albumName%></h1>

                    <div class="row">

                        <div class="col-sm-3 text-right pull-right">
                            <a href=<%=loginURL%>><img class="img-responsive sign-in" src="assets/images/signin-btn.png"></a>
                        </div>
                    </div>

                    <div id="displayPhotos" class="block-grid-lg-6 block-grid-md-5 block-grid-sm-4 block-grid-xs-2 thumbnail-row">
                        Oops! Someone must have deleted the album!
                    </div>

                </div>

            </div>

        </div>
    </body>
    <%}%>
</html>
