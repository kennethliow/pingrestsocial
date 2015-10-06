<%
    boolean fail = session.getAttribute("fail")!=null ? true : false;
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>#IS434</title>

        <!-- Bootstrap core CSS -->
        <link href="assets/css/bootstrap.min.css" rel="stylesheet">

        <!-- Custom styles for this template -->
        <link href="assets/css/hashed.css" rel="stylesheet">
    </head>

    <body>
        <div class="container">
            <div class="intro-main">
                <img class="logo img-responsive center-block" src="assets/images/pings_side.jpg"/>
                <p class="header">Social Analytics. Made Easier.</p>
                <p class="sub-header">
                    <div id="legend">
                        <legend class="">Administrator Login</legend>
                    </div>    
                    <div class="row">
                        <div
                            class="fb-like"
                            data-share="true"
                            data-width="450"
                            data-show-faces="true">
                        </div>
                        <% if(fail){ %>
                        <div class="col-lg-8 col-lg-offset-2">
                            <div class="alert alert-danger" role="alert">
                                <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
                                <span class="sr-only">Error:</span>
                                Invalid Username/Password
                            </div>
                        </div>
                        <% } %>
                        <form id="login-form" action="LoginServlet" method="post" role="form" style="display: block;">
                            <div class="col-lg-8 col-lg-offset-2">
                                <div class="form-group">
                                    <input type="text" name="username" id="username" tabindex="1" class="form-control" placeholder="Username" value="">
                                </div>
                                <div class="form-group">
                                    <input type="password" name="password" id="password" tabindex="2" class="form-control" placeholder="Password">
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-sm-6 col-sm-offset-3">
                                        <input type="submit" name="login-submit" id="login-submit" tabindex="4" class="form-control btn btn-login" value="Log In">
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </p>
            </div>
        </div><!-- /.container -->

        <!-- Bootstrap core JavaScript
        ================================================== -->
        <!-- Placed at the end of the document so the pages load faster -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
    </body>
</html>
