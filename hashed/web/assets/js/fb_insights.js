// Word Cloud Stuff
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
}, 7500);


// Facebook For Word Cloud
function findHashtags(searchText) {
    var regexp = /\#\w\w+\s?/g
    result = searchText.match(regexp);
    if (result) {
        result.map(function(s) { return s.trim() });
        return result;
    } else {
        return false;
    }
}

function getImpressions (data, callback) {
    FB.api(
        "/" + data.id + "/insights/post_impressions",
        'GET' , 
        {fields: 'values'}, 
        callback
    );
}

function getComments(data) {
    FB.api(
        "/" + data + "/comments",
        'GET' , 
        {}, 
        function (response) {
            if(response.data.length > 0) {
                for(i = 0 ; i < response.data.length ; i ++){
                    thisData = response.data[i];
                    if(detectLanguage(thisData.message) != "Thai" ) {

                    }
                }
            }
        }
    );
}


// Miscellaneous
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