package models;

import java.util.ArrayList;
import java.util.List;
import org.parse4j.ParseException;
import org.parse4j.ParseObject;
import org.parse4j.ParseQuery;

public class Album {
    private ArrayList<String> photos;
    private ArrayList<String> photoLinks;
    private String name;
    private User owner;
    private String albumCover;
    private String albumLink;
    private String albumID;
    private ArrayList<User> taggedUsers;
    private ArrayList<String> taggedEmails;
    
    public Album(String name, User owner){
        this.name = name;
        photos = new ArrayList<String> ();
        photoLinks = new ArrayList<String> ();
        this.owner = owner;
        albumCover = "";
        albumLink = "";
        taggedUsers = new ArrayList<User>();
        taggedEmails = new ArrayList<String>();
    }
    
    public Album(String name, ArrayList<String> photos, ArrayList<String> photoLinks, User owner, String albumCover, String albumLink, String albumID, ArrayList<User> taggedUsers, ArrayList<String> taggedEmails){
        this.name = name;
        this.photos = photos;
        this.photoLinks = photoLinks;
        this.owner = owner;
        this.albumCover = albumCover;
        this.albumLink = albumLink;
        this.albumID = albumID;
        this.taggedUsers = taggedUsers;
        this.taggedEmails = taggedEmails;
    }
    
    public String getName(){
        return name;
    }
    
    public String getAlbumID(){
        return albumID;
    }
    
    public String getAlbumCover(){
        return albumCover;
    }
    
    public ArrayList<String> getPhotos(){
        return photos;
    }
    
    public ArrayList<String> getPhotoLinks(){
        return photoLinks;
    }
    
    public ArrayList<User> getTaggedUsers(){
        return taggedUsers;
    }
    
    public ArrayList<String> getTaggedEmails(){
        return taggedEmails;
    }
    
    public void setTaggedUsers(ArrayList<User> taggedUsers){
        this.taggedUsers = taggedUsers;
    }
    
    public void setTaggedEmails(ArrayList<String> taggedEmails){
        this.taggedEmails = taggedEmails;
    }
    
    public void removeTaggedEmail(String email){
        taggedEmails.remove(email);
    }
    
    public void addTaggedUser(User user){
        taggedUsers.add(user);
    }
    
    public void addPhoto(String photo, String photoLink){
        if (photos.isEmpty()){
            albumCover = photoLink;
        }
        photos.add(photo);
        photoLinks.add(photoLink);
    }
    
    public void removePhotosWithPhotoLink(String photoLink){
        int locationToRemove = photoLinks.indexOf(photoLink);
        if (locationToRemove != -1){
            photos.remove(locationToRemove);
            photoLinks.remove(locationToRemove);
        }
        if (locationToRemove == 0 ){
            if (!photoLinks.isEmpty()){
                albumCover = photoLinks.get(0);
            } else {
                albumCover = "";
            }
        }
    }
    
    public User getOwner(){
        return owner;
    }
    
    public void setAlbumCover(String albumCover){
        this.albumCover = albumCover;
    }
    
    public String save(User user) throws ParseException{
        ParseQuery<ParseObject> query = ParseQuery.getQuery("Album");
        query.whereEqualTo("userid", user.getUserID());
        query.whereEqualTo("albumname", name.trim());
        List<ParseObject> albumRetrieved = query.find();
        ParseObject album = null;
        if (albumRetrieved == null  || albumRetrieved.isEmpty()){
            album = new ParseObject("Album");
        } else {
            album = albumRetrieved.get(0);
        }
        album.put("userid", owner.getUserID());
        album.put("albumname", name);
        album.put("username", owner.getUsername());
        String compiledMediaID = "";
        for (int i = 0; i < photos.size(); i++){
            String mediaID = photos.get(i);
            compiledMediaID += mediaID;
            if (i != photos.size()-1){
                compiledMediaID += ",";
            }
        }
        album.put("mediaid", compiledMediaID);
        String compiledPhotoLinks = "";
        for (int i = 0; i < photoLinks.size(); i++){
            String photoLink = photoLinks.get(i);
            compiledPhotoLinks += photoLink;
            if (i != photoLinks.size()-1){
                compiledPhotoLinks += ",";
            }
        }
        album.put("photolinks", compiledPhotoLinks);
        album.put("link", albumLink);
        if (albumCover == null){
            album.put("cover_art", "");
        } else {
            album.put("cover_art", albumCover);
        }
        String compiledUsernames = "";
        for (int i = 0; i < taggedUsers.size(); i++){
            User retrievedUser = taggedUsers.get(i);
            compiledUsernames += retrievedUser.getUsername();
            if (i != taggedUsers.size()-1){
                compiledUsernames += ",";
            }
        }
        album.put("tagged_users", compiledUsernames);
        String compiledEmails = "";
        for (int i = 0; i < taggedEmails.size(); i++){
            String email = taggedEmails.get(i);
            compiledEmails += email;
            if (i != taggedEmails.size()-1){
                compiledEmails += ",";
            }
        }
        album.put("tagged_emails", compiledEmails);
        album.save();
        albumID = album.getObjectId();
        return albumID;
    }
}