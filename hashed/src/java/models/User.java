package models;

import org.parse4j.ParseException;
import org.parse4j.ParseObject;
import org.parse4j.ParseQuery;

public class User {

    private String userID;
    private String objectID;
    private String fullname;
    private String username;
    private String profilePicture;
    private String email;

    public User(String userID, String objectID, String fullname, String username, String profilePicture) {
        this(userID, objectID, fullname, username, profilePicture, "");
    }
    
    public User(String userID, String objectID, String fullname, String username, String profilePicture, String email){
        this.userID = userID;
        this.objectID = objectID;
        this.fullname = fullname;
        this.username = username;
        this.profilePicture = profilePicture;
        this.email = email;
    }

    public User(String userID, String fullname) {
        this.userID = userID;
        this.fullname = fullname;
    }

    public String getUserID() {
        return userID;

    }

    public String getObjectID() {
        return objectID;
    }

    public String getFullName() {
        return fullname;
    }

    public String getEmail() {
        return email;
    }

    public String toString() {
        return username + " , ";
    }

    public String getProfilePicture() {
        return profilePicture;
    }

    public String getUsername() {
        return username;
    }
    
    public void setEmail(String email){
        this.email = email;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }
    
    public void save() throws ParseException {
        ParseObject user = null;
        if (objectID.equals("")){
             user = new ParseObject("PhotoOwner");
        } else {
            ParseQuery<ParseObject> query = ParseQuery.getQuery("PhotoOwner");
            query.whereEqualTo("objectId", objectID);
            user = query.find().get(0);
        }
        user.put("userid", userID);
        user.put("groupname", "");
        user.put("username", username);
        user.put("fullname", fullname);
        user.put("profilepicture", profilePicture);
        user.put("email", email);
        user.save();
        if (objectID.equals("")){
            objectID = user.getObjectId();
        }
    }
}
