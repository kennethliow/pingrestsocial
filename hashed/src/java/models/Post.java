package models;

import java.util.ArrayList;
import org.json.simple.JSONObject;

public class Post {
    private ArrayList <String> tags;
    private String type;
    private String location; //null if no location
    private long likes;
    private String imageLink;
    private ArrayList <String> taggedUsers;
    private String caption; //null if no caption
    private String ID;
    private String user;

    public Post(ArrayList<String> tags, String type, String location, long likes, String imageLink, ArrayList<String> taggedUsers, String caption, String ID, String user) {
        this.tags = tags;
        this.type = type;
        this.location = location;
        this.likes = likes;
        this.imageLink = imageLink;
        this.taggedUsers = taggedUsers;
        this.caption = caption;
        this.ID = ID;
        this.user = user;
    }

    public ArrayList<String> getTags() {
        return tags;
    }

    public void setTags(ArrayList<String> tags) {
        this.tags = tags;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public long getLikes() {
        return likes;
    }

    public void setLikes(long likes) {
        this.likes = likes;
    }

    public String getImageLink() {
        return imageLink;
    }

    public void setImageLink(String imageLink) {
        this.imageLink = imageLink;
    }

    public ArrayList<String> getTaggedUsers() {
        return taggedUsers;
    }

    public void setTaggedUsers(ArrayList<String> taggedUsers) {
        this.taggedUsers = taggedUsers;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public String getID() {
        return ID;
    }

    public void setID(String ID) {
        this.ID = ID;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }
    
    // for JSON print on search servlet
    @Override
    public String toString(){
        JSONObject jsonMap = new JSONObject();
        jsonMap.put("id", ID);
        jsonMap.put("tags", tags);
        jsonMap.put("type", type);
        jsonMap.put("location", location);
        jsonMap.put("likes", likes);
        jsonMap.put("image_link", imageLink);
        jsonMap.put("tagged_users", taggedUsers);
        jsonMap.put("caption", caption);
        jsonMap.put("user", user);
        return jsonMap.toJSONString();
    }
    
}
