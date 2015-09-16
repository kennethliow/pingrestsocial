package models;

import java.util.ArrayList;
import java.util.List;
import org.parse4j.Parse;
import org.parse4j.ParseException;
import org.parse4j.ParseObject;
import org.parse4j.ParseQuery;

public class UserManager {
    private ArrayList <User> userList;
    
    public UserManager() throws ParseException{
        userList = new ArrayList <User> ();
        loadUsers();
    }
    
    private void loadUsers() throws ParseException{
        Parse.initialize("P0CrqeHC9sOY0qNzO1Gl9NZfbVPlIGSvhvAc4c9N", "pors7XxI3oWEHwARoKLkXJmROmFZorbq8zL5cuyH");
        ParseQuery<ParseObject> query = ParseQuery.getQuery("PhotoOwner");
        query.addAscendingOrder("PhotoOwner");
        List<ParseObject> usersRetrieved = query.find();
        if (usersRetrieved != null) {
            for (ParseObject retrieve : usersRetrieved) {
                String userID = retrieve.getString("userid");
                String username = retrieve.getString("username");
                String fullname = retrieve.getString("fullname");
                String profilePicture = retrieve.getString("profilepicture");
                String email = retrieve.getString("email");
                User newUser = new User (userID, retrieve.getObjectId(), fullname, username, profilePicture, email);
                userList.add(newUser);
            }
        }
    }
    
    public User getUserByUsername(String username){
        for (User user : userList){
            if (user.getUsername().equals(username)){
                return user;
            }
        }
        return null;
    }
    
    public ArrayList <User> getUsers(){
        return userList;
    }
     
    public void addUser(User user){
        userList.add(user);
    }
    
    public void updateUser(User user, String fullname, String username, String profilePicture){
        user.setFullname(fullname);
        user.setUsername(username);
        user.setProfilePicture(profilePicture);
    } 
}
