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

        <title>#IS434 Pings Restaurant Group</title>

        <!-- Bootstrap core CSS -->
        <link href="assets/css/bootstrap.min.css" rel="stylesheet">

        <!-- Custom styles for this template -->
        <link href="assets/css/hashed.css" rel="stylesheet">
        <link href="assets/css/blockgrid.css" rel="stylesheet">
        <link href="assets/css/bootstrap-select.css" rel="stylesheet">
        <link href="assets/css/bootstrap-select.min.css" rel="stylesheet">
        <link href="assets/css/nv.d3.css" rel="stylesheet" type="text/css">
        
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
        <script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.2/d3.min.js" charset="utf-8"></script>
        <script src="assets/js/nv.d3.js"></script>
        <script src="assets/js/stream_layers.js"></script>
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
            
            function showGraph(chVal, data) {
                nv.addGraph(function() {
                    var chart = nv.models.lineChart().x( function(d){return new Date(d.x);} );

                    chart.xScale(d3.time.scale());
                    chart.xAxis.ticks(d3.time.days, 1).tickFormat(function(d) { return d3.time.format("%d %b")(d) });
                    chart.yAxis.tickFormat(d3.format(',.f'));
                    d3.select('#' + chVal + ' svg')
                        .datum(data)
                        .call(chart);

                    nv.utils.windowResize(chart.update);
                    return chart;
                });
            }
            
            function runData(response) {
                FB.api(
                    "/258437627628348/insights/page_impressions?fields=values&period=week",
                    'GET' , 
                    {fields: "values"}, 
                    getData
                );
                FB.api(
                    "/258437627628348/insights/page_engaged_users?fields=values&period=week",
                    'GET' , 
                    {fields: "values"}, 
                    getData2
                );
            }
            var j = 0; var k = 0;
            var page_impressions = [{
                key : "Page Impressions",
                values : []
            }];
            var page_engagement = [{
                key : "Page Engagement",
                values : []
            }];
            function getData(response) {
                var arr = response.data[0].values;
                for(i = arr.length-1; i >=0 ; i--){
                    page_impressions[0].values.push({x : arr[i].end_time.split('T')[0], y: arr[i].value});
                }
                if (j<2 && response.paging.previous != "undefined"){
                    FB.api(response.paging.previous, getData);
                } else {
                    showGraph('chart', page_impressions);
                }
                j++;
            }
            function getData2(thisResp) {
                var arr = thisResp.data[0].values;
                for(i = arr.length-1; i >=0 ; i--){
                    page_engagement[0].values.push({x : arr[i].end_time.split('T')[0], y: arr[i].value});
                }
                if (k<2 && thisResp.paging.previous != "undefined"){
                    FB.api(thisResp.paging.previous, getData2);
                } else {
                    showGraph('chart2', page_engagement);
                }
                k++;
            }
            $(function() {
		$.ajax({
                    type: "GET",
                    dataType: "jsonp",
                    cache: true,
                    url: "https://api.instagram.com/v1/users/454859018/?access_token=2178266985.d4f545c.7d3bf864e8224846aa10a883c889e935",
                        success: function(data) {
                            console.log(data);
                            var ig_count = data.data.counts.followed_by.toString();
                            var med_count = data.data.counts.media.toString();
                            ig_count = add_commas(ig_count);
                            $(".instagram_count").html("").html(ig_count);
                            $(".instagram_media").html("").html(med_count);
                        }
                    });
                    function add_commas(number) {
                        if (number.length > 3) {
                                var mod = number.length % 3;
                                var output = (mod > 0 ? (number.substring(0,mod)) : '');
                                for (i=0 ; i < Math.floor(number.length / 3); i++) {
                                        if ((mod == 0) && (i == 0)) {
                                                output += number.substring(mod+ 3 * i, mod + 3 * i + 3);
                                        } else {
                                                output+= ',' + number.substring(mod + 3 * i, mod + 3 * i + 3);
                                        }
                                }
                                return (output);
                        } else {
                                return number;
                        }
                    }
            });
        </script> 
        
        <% session.setAttribute("location", "explore");%>
        
        <div class="container-fluid">
            <div class="row">
                <%@include file="sidebar.jsp"%> 

                <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
                    <div class="row" style="height: 50px;">
                        <div style="width: 980px; height: 20px; position: relative; font-weight: bold;font-size:20px;">
                            Ping's Restaurant Group
                            <hr style="margin-top: 0px; border-top: 1px solid #c9c9c9;">
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 col-lg-6" style="padding-right: 45px;">
                            <img class="col-md-12 col-lg-12" src="assets/images/ping1.jpg" style="height:150px;padding: 0px;">
                            <div class="col-md-12 col-lg-12" style="padding: 0px;text-align: justify;">
                                <br>This website was designed and created by Singapore Management University students, including Kenneth Liow, Ng Ying Neng, Leong Hoi Chuen, Eric Ong and Sulovna Susant, as part of the IS434 - Social Analytics and Applications Module. The goal of this website is to help our client (Ping's Restaurant Group) better understand and analyze their existing social media and also conduct social media listening to identify the latest trends in the food and beverage industry.
                                <br><br>Incorporate into this website are multiple tools to achieve the mentioned goals. This includes two key segments: (1) Facebook Insights and (2) Instagram Analysis. These social media tools perform analysis on both existing available data as well as external information crawled.
                                <br><br>The team is confident that this application will aid in your analysis and we look forward to hearing positive feedback from the management! 
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-6" style="padding: 0px;">
                            <div class="col-md-12 col-lg-12" style="padding: 0px;">
                                <div class="col-md-12 col-lg-12" style="padding: 0px;">
                                    <b>Overview of Facebook Insights</b>
                                    <hr style="margin: 0px;">
                                    <div id="chart" class='with-3d-shadow with-transitions' style="height:180px">
                                        <svg></svg>
                                    </div>
                                    <hr style="margin: 0px 0px 15px;">
                                    <div id="chart2" class='with-3d-shadow with-transitions' style="height:180px">
                                        <svg></svg>
                                    </div>
                                </div>
                                <div class="col-md-12 col-lg-12" style="padding: 0px;"></div>
                                <div class="col-md-12 col-lg-12" style="padding: 0px;">
                                    <b>Instagram Key Statistics</b>
                                    <hr style="margin: 0px;">
                                    <div style="padding: 2%;">
                                        <div class="col-md-6 col-lg-6 curve" style="margin-left:-5px;">
                                            <div class="text_cur"><b>Followers</b></div>
                                        </div>
                                        <div class="col-md-6 col-lg-6 curve" style="margin-left:4px;">
                                            <div class="text_cur"><b>No of Posts</b></div>
                                        </div>
                                        <div class="col-md-6 col-lg-6 curve_bot instagram_count" style="margin-left:-5px;">
                                            #
                                        </div>
                                        <div class="col-md-6 col-lg-6 curve_bot instagram_media" style="margin-left:4px;">
                                            #
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div><!-- End of main -->
            </div><!-- End of row -->
        </div> <!-- End of container -->
    </body>
</html>
