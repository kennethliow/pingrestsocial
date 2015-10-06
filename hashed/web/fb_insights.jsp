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

        <title>#IS434 Test</title>

        <!-- Bootstrap core CSS -->
        <link href="assets/css/bootstrap.min.css" rel="stylesheet">

        <!-- Custom styles for this template -->
        <link href="assets/css/hashed.css" rel="stylesheet">
        <link href="assets/css/blockgrid.css" rel="stylesheet">
        <link href="assets/css/bootstrap-select.css" rel="stylesheet">
        <link href="assets/css/bootstrap-select.min.css" rel="stylesheet">
    </head>
    <body>
        <script>
            setTimeout(function(){
                var wordCloudArr = [];
                for(var tag in hashtagLibrary) {
                    wordCloudArr.push({
                        text: tag,
                        size: hashtagLibrary[tag] / 4500
                    });
                }
                createWordCloud(wordCloudArr);
                $("#loadingscreen").fadeOut("slow");
            }, 6000);
            
            var hashtagLibrary = {};
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
                hashtagLibrary = {};
                FB.api(
                    "/258437627628348/feed?limit=100",
                    'GET' , 
                    {}, 
                    dummyRunData
                );
            }
            
            function dummyRunData (response) {
                runData2(response);
            }
            var msg = "";
            function runData2(response) {
                for(i = 0 ; i < response.data.length ; i ++){
                    thisData = response.data[i];
                    if(typeof thisData != "undefined" && typeof thisData.message != "undefined" && thisData.message.indexOf("#")>-1) {
                        msg = thisData.message;
                        getImpressions(thisData, runData3);
                    }
                    // getComments(thisData.id);
                }
                if (typeof response.paging != "undefined" && response.paging.next != "undefined"){
                    FB.api(response.paging.next, runData2);
                }
            }

            function runData3(resp) {
                runData4 (resp.data[0].values[0].value);
            }
            
            function runData4 (imp) {
                hashtags = findHashtags(msg);
                for(j = 0 ; j < hashtags.length ; j++) {
                    tag = hashtags[j].replace(/[^A-Za-z]+/g, '');
                    if(tag in hashtagLibrary) {
                        hashtagLibrary[tag] = hashtagLibrary[tag] + imp;
                    } else {
                        hashtagLibrary[tag] = imp;
                    }
                }
            }
        </script> 
        
        <% session.setAttribute("location", "explore");%>
        
        <div class="container-fluid">
            <div class="row">

                <%@include file="sidebar.jsp"%> 

                <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
                    <div style="position: absolute; left: 0px; top: 20px; width: 980px; height: 550px; background-color: white; z-index: 2;" id="loadingscreen">
                        <img src="assets/images/Loading.gif" alt="Processing" style="display: block; margin: 0 auto;width:100px;margin-top:200px;">
                    </div>
                    <div id="mainbody" style="width: 980px; height: 505px; position: relative;">
                        
                    </div>
                </div><!-- End of main -->
            </div><!-- End of row -->
        </div> <!-- End of container -->

        

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
        <script src="assets/js/cld-min.js"></script>
        <script src="assets/js/fb_insights.js"></script>
        <script src="assets/js/d3.js"></script>
        <script src="assets/js/d3.layout.cloud.js"></script>
        <script>
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
        </script>
        
        <script>
            var fill = d3.scale.category20();
            function createWordCloud(wordArr) {
                d3.layout.cloud()
                    .words(wordArr)
                    .rotate(function() { return ~~(Math.random() * 2) * 90; })
                    .font("Impact")
                    .fontSize(function(d) { return d.size; })
                    .on("end", draw)
                    .start();
            }
            
            function draw(words) {
              d3.select("#mainbody").append("svg")
                .attr({
                    "width": '1000px',
                    "height": '550px'
                })
                .append("g")
                  .attr("transform", "translate(480,220)")
                .selectAll("#mainbody")
                  .data(words)
                .enter().append("text")
                  .style("font-size", function(d) { return d.size + "px"; })
                  .style("font-family", "Impact")
                  .style("fill", function(d, i) { return fill(i); })
                  .attr("text-anchor", "middle")
                  .attr("transform", function(d) {
                    return "translate(" + [d.x, d.y+30] + ")rotate(" + d.rotate + ")";
                  })
                  .text(function(d) { return d.text; });
            }
        </script>
    </body>
</html>
