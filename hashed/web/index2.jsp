<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>#hashed</title>

        <!-- Bootstrap core CSS -->
        <link href="assets/css/bootstrap.min.css" rel="stylesheet">

        <!-- Custom styles for this template -->
        <link href="assets/css/hashed.css" rel="stylesheet">
    </head>

    <body>
        <% String currentURL = request.getRequestURL().toString();
        String loginURL = "";
        if (currentURL.indexOf("localhost") != -1){
            session.setAttribute("environment", "development");
            loginURL = "https://api.instagram.com/oauth/authorize/?client_id=ae09aaad138048e9a144317336a003f7&redirect_uri=http://localhost:8084/hashed/LoginServlet&response_type=code";
        } else {
            session.setAttribute("environment", "staging");
            loginURL = "https://api.instagram.com/oauth/authorize/?client_id=4a8b2ab79fb34cc5804eb18aec833e37&redirect_uri=http://hashed-g2t9.rhcloud.com/LoginServlet&response_type=code";
        }%>
        
        <div class="container">
            <div class="intro-main">
                <img class="logo img-responsive center-block" src="assets/images/hashedpink-logo.png"/>
                <p class="header">Sharing and tagging. Made easier.</p>
                <p class="sub-header">
                    A place where simplicity meets functionality, sharing and searching photos from Instagram has never been easier. 
                    Within seconds, you will be sharing photos with the people you care about. Experience a whole new way of looking at photos with hashed.
                </p>
                <a href="<%=loginURL%>"><img class="sign-in" src="assets/images/signin-btn.png"/></a>    
            </div>
        </div><!-- /.container -->

        <!-- Bootstrap core JavaScript
        ================================================== -->
        <!-- Placed at the end of the document so the pages load faster -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
    </body>
</html>
