package controllers;

import java.util.ArrayList;
import java.util.concurrent.ConcurrentHashMap;
import models.Post;
import models.PostManager;

public class PostController {
    private final PostManager postManager;
    
    public PostController(){
        postManager = new PostManager();
    }
    
    public void add(String term, ArrayList<String> tags, String type, String location, long likes, String imageLink, ArrayList<String> taggedUsers, String caption, String ID, String user){
        postManager.add(term, tags, type, location, likes, imageLink, taggedUsers, caption, ID, user);
    }
    
    public void clearMap(){
        postManager.clearMaps();
    }
    
    public ConcurrentHashMap <String, Post> getMatchedMap(){
        return postManager.getMatchedMap();
    }
    
    public ArrayList <Post> getSearchResults(String term){
        return postManager.getSearchResults(term);
    }
}
