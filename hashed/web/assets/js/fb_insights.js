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