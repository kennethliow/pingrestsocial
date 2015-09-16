package models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.concurrent.ConcurrentHashMap;

public class PostManager {
    private final ConcurrentHashMap <String, Post> checkingMap;
    private final ConcurrentHashMap <String, Post> matchedMap;
    private final HashMap <String, ArrayList<Post>> searchMap;
    
    public PostManager(){
        checkingMap = new ConcurrentHashMap <String, Post> ();
        matchedMap = new ConcurrentHashMap <String, Post> ();
        searchMap = new HashMap <String, ArrayList <Post>> ();
    }
    
    public void add(String term, ArrayList<String> tags, String type, String location, long likes, String imageLink, ArrayList<String> taggedUsers, String caption, String ID, String user){
        Post post = new Post(tags, type, location, likes, imageLink, taggedUsers, caption, ID, user);
        if (checkingMap.containsKey(ID)) {
            matchedMap.put(ID, post);
        } else {
            checkingMap.put(ID, post);
        }
        ArrayList <Post> results = searchMap.get(term);
        if (results == null){
            results = new ArrayList <Post> ();
        }
        results.add(post);
        searchMap.put(term, results);
    }
    
    public void clearMaps(){
        checkingMap.clear();
        matchedMap.clear();
        searchMap.clear();
    }
    
    public ConcurrentHashMap <String, Post> getMatchedMap(){
        return matchedMap;
    }
    
    public ArrayList <Post> getSearchResults (String term) {
        return searchMap.get(term);
    }
}
