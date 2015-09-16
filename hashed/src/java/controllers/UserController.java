package controllers;

import java.util.ArrayList;
import java.util.HashMap;
import models.Group;
import models.GroupManager;
import models.User;
import models.UserManager;
import org.parse4j.Parse;
import org.parse4j.ParseException;
import org.parse4j.ParseObject;

public class UserController {

    private User userLoggedIn;
    private UserManager userManager;
    private GroupManager groupManager;

    public UserController(String userID, String username, String fullname, String profilePicture) throws ParseException {
        userManager = new UserManager();
        User user = userManager.getUserByUsername(username);
        if (user == null) {
            Parse.initialize("P0CrqeHC9sOY0qNzO1Gl9NZfbVPlIGSvhvAc4c9N", "pors7XxI3oWEHwARoKLkXJmROmFZorbq8zL5cuyH");
            ParseObject parseUser = new ParseObject("PhotoOwner");
            parseUser.put("userid", userID);
            parseUser.put("groupname", "");
            parseUser.put("username", username);
            parseUser.put("fullname", fullname);
            parseUser.put("profilepicture", profilePicture);
            parseUser.put("email", "");
            parseUser.save();
            userLoggedIn = new User(userID, parseUser.getObjectId(), fullname, username, profilePicture);
        } else {
            userLoggedIn = user;
        }
        groupManager = new GroupManager(this);
    }

    public User getUserLoggedIn() {
        return userLoggedIn;
    }

    public User getUserByUsername(String username) {
        return userManager.getUserByUsername(username);
    }

    public HashMap<String, Group> getGroupMap() {
        return groupManager.getGroupMap();
    }

    public void createGroup(String groupName, User user, ArrayList<User> members, ArrayList<String> emails) throws ParseException {
        groupManager.createGroup(groupName, user, members, emails);
    }

    public void updateGroup(String oldGroupName, String newGroupName, ArrayList<User> members, ArrayList<String> emails) throws ParseException {
        groupManager.updateGroup(oldGroupName, newGroupName, members, emails);
    }

    public Group getGroupByGroupName(String groupName) {
        return groupManager.getGroupByGroupName(groupName);
    }
    
    public Group getGroupByID(String groupID){
        return groupManager.getGroupByID(groupID);
    }

    public void removeMember(String groupName, String membername) throws ParseException {
        HashMap<String, Group> groupList = getGroupMap();
        Group group = groupList.get(groupName);
        User user = getUserByUsername(membername.trim());
        groupManager.removeGroupMember(group, user);
    }

    public void deleteGroup(String groupname) throws ParseException {
        Group group = groupManager.getGroupByGroupName(groupname);
        groupManager.deleteGroup(group);
    }
    
    public void updateUser(User user, String fullname, String username, String profilePicture){
        userManager.updateUser(user, fullname, username, profilePicture);
    }
}
