package models;

import controllers.PostController;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class SearcherRunnable implements Runnable {
    
    private final String term;
    private final String code;
    private String urlString;
    private final PostController postController;
    
    public SearcherRunnable(String term, String code, PostController postController){
        this.term = term;
        this.code = code;
        urlString = "https://api.instagram.com/v1/tags/" + term + "/media/recent?access_token=" + code;
        this.postController = postController;
    }
    
    public SearcherRunnable(String term, String code, String urlString, PostController postController){
        this.term = term;
        this.code = code;
        this.urlString = urlString;
        this.postController = postController;
    }
    
    public void run(){
        while (urlString != null){
            try {
                URL url = new URL(urlString);
                         
                HttpURLConnection urlcon = (HttpURLConnection) url.openConnection();
                urlcon.setRequestMethod("GET");
                urlcon.setRequestProperty("Content-Type", "application/json");

                // get the input from the request
                BufferedReader in = new BufferedReader(new InputStreamReader(urlcon.getInputStream()));
                String res = in.readLine();
                in.close();

                // retrieving response
                Object obj = JSONValue.parse(res);
                JSONObject jObj = (JSONObject) obj;
                urlString = (String)((JSONObject)jObj.get("pagination")).get("next_url");
               
                JSONArray dataArray = (JSONArray) jObj.get("data");
                for (Object arrayObject : dataArray){
                    JSONObject dataObject = (JSONObject) arrayObject;
                    JSONArray tagsArray = (JSONArray) dataObject.get("tags");
                    ArrayList <String> tags = new ArrayList <String> ();
                    tags.addAll(tagsArray);
                    String type = (String) dataObject.get("type");
                    JSONObject locationObject = (JSONObject) dataObject.get("location");
                    String location = null;
                    if (locationObject != null){
                        location = locationObject.toString();
                    }
                    long likes = (Long) ((JSONObject) dataObject.get("likes")).get("count");
                    JSONObject imageObject = (JSONObject) ((JSONObject) dataObject.get("images")).get("standard_resolution");
                    String imageLink = imageObject.get("url").toString();
                    JSONArray taggedUsersArray = (JSONArray) dataObject.get("users_in_photo");
                    ArrayList <String> taggedUsers = new ArrayList <String> ();
                    for (Object taggedUserObject : taggedUsersArray){
                        JSONObject taggedUser = (JSONObject) taggedUserObject;
                        String taggedUsername = ((JSONObject) taggedUser.get("user")).get("username").toString();
                        taggedUsers.add(taggedUsername);
                    }
                    JSONObject captionObject = (JSONObject) dataObject.get("caption");
                    String caption = null;
                    if (captionObject != null){
                        caption = captionObject.get("text").toString();
                    }
                    String ID = (String) dataObject.get("id");
                    String user = (String) ((JSONObject) dataObject.get("user")).get("username");
                    
                    postController.add(term, tags, type, location, likes, imageLink, taggedUsers, caption, ID, user);      
                }
                
            } catch (MalformedURLException ex) {
                Logger.getLogger(SearcherRunnable.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IOException ex) {
                Logger.getLogger(SearcherRunnable.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
