<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="testuser.jsp"/> 

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

        <title>#IS434 Facebook Insights</title>

        <!-- Bootstrap core CSS -->
        <link href="assets/css/bootstrap.min.css" rel="stylesheet">

        <!-- Custom styles for this template -->
        <link href="assets/css/hashed.css" rel="stylesheet">
        <link href="assets/css/blockgrid.css" rel="stylesheet">
        <link href="assets/css/bootstrap-select.css" rel="stylesheet">
        <link href="assets/css/bootstrap-select.min.css" rel="stylesheet">
        
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script> 
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/bootstrap-select.min.js"></script>
        <script src="assets/js/jquery.lazyload.min.js" type="text/javascript"></script>
        <script src="assets/js/spin.min.js" type="text/javascript"></script>
        <script src="assets/js/bloxhover.jquery.min.js" type="text/javascript"></script>
        <script src="assets/js/cld-min.js"></script>
        <script src="assets/js/d3.js"></script>
        <script src="assets/js/amcharts.js"></script>
        <script src="assets/js/serial.js"></script>
        <script src="assets/js/fb_demographics.js"></script>
    </head>
    <body>
        <script>
            window.fbAsyncInit = function() {
              FB.init({
                appId      : '1531128673845258',
                xfbml      : true,
                version    : 'v2.4'
              });
              FB.login(function(response) {
                if (response.authResponse) {
                  runData(response);
                }
              });
            };

            (function(d, s, id){
               var js, fjs = d.getElementsByTagName(s)[0];
               if (d.getElementById(id)) {return;}
               js = d.createElement(s); js.id = id;
               js.src = "//connect.facebook.net/en_US/sdk.js";
               fjs.parentNode.insertBefore(js, fjs);
            }(document, 'script', 'facebook-jssdk'));

            function runData(response) {
                FB.api(
                    "/258437627628348/insights/page_fans_gender_age",
                    'GET' , 
                    {fields: "values"}, 
                    runData2
                );
            }
            
            function runData2 (response) {
                var male = [], female = [];
                breakdown = response.data[0].values[0].value;
                var total = 0;
                for (eachVal in breakdown) {
                    total += breakdown[eachVal];
                }
                var dataBd = [
                    {
                        "age": "13-17",
                        "male": parseFloat(breakdown["M.13-17"]/total * -100).toFixed(2),
                        "female": parseFloat(breakdown["F.13-17"]/total * 100).toFixed(2)
                    },{
                        "age": "18-24",
                        "male": parseFloat(breakdown["M.18-24"]/total * -100).toFixed(2),
                        "female": parseFloat(breakdown["F.18-24"]/total * 100).toFixed(2)
                    },{
                        "age": "25-34",
                        "male": parseFloat(breakdown["M.25-34"]/total * -100).toFixed(2),
                        "female": parseFloat(breakdown["F.25-34"]/total * 100).toFixed(2)
                    },{
                        "age": "35-44",
                        "male": parseFloat(breakdown["M.35-44"]/total * -100).toFixed(2),
                        "female": parseFloat(breakdown["F.35-44"]/total * 100).toFixed(2)
                    },{
                        "age": "45-54",
                        "male": parseFloat(breakdown["M.35-44"]/total * -100).toFixed(2),
                        "female": parseFloat(breakdown["F.35-44"]/total * 100).toFixed(2)
                    },{
                        "age": "55-64",
                        "male": parseFloat(breakdown["M.35-44"]/total * -100).toFixed(2),
                        "female": parseFloat(breakdown["F.35-44"]/total * 100).toFixed(2)
                    },{
                        "age": "65+",
                        "male": parseFloat(breakdown["M.65+"]/total * -100).toFixed(2),
                        "female": parseFloat(breakdown["F.65+"]/total * 100).toFixed(2)
                    }
                ];
                displayDemographic(dataBd);
            }
            
        </script> 
        
        <% session.setAttribute("location", "explore");%>
        
        <div class="container-fluid">
            <div class="row">
                <%@include file="sidebar.jsp"%> 

                <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
                    <div style="display:none; position: absolute; left: 0px; top: 20px; width: 1000px; height: 550px; background-color: white; z-index: 2;" id="loadingscreen">
                        <img src="assets/images/Loading.gif" alt="Processing" style="display: block; margin: 0 auto;width:100px;margin-top:200px;">
                    </div>
                    <div style="width: 980px; height: 20px; position: relative; font-weight: bold;font-size:20px;">
                        Ping's Restaurant Group Demographics
                        <hr style="margin-top: 0px; border-top: 1px solid #c9c9c9;">
                    </div>
                    <div id="chartdiv" style="width: 100%; height: 500px; font-size:11px; position: relative; margin-top:25px;"></div>
                </div><!-- End of main -->
            </div><!-- End of row -->
        </div> <!-- End of container -->
    </body>
</html>
