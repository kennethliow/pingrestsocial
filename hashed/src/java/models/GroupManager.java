package models;

import controllers.UserController;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import org.parse4j.Parse;
import org.parse4j.ParseException;
import org.parse4j.ParseObject;
import org.parse4j.ParseQuery;

public class GroupManager {

    //groupname, group object
    private HashMap<String, Group> groupMap;

    public GroupManager(UserController userController) throws ParseException {
        groupMap = new HashMap<String, Group>();
        loadGroups(userController);
    }

    public Group getGroupByGroupName(String groupname) {
        return groupMap.get(groupname);
    }
    
    public Group getGroupByID(String groupID){
        Collection groups = groupMap.values();
        for (Object groupObj : groups){
            Group group = (Group)groupObj;
            if (group.getGroupID().equals(groupID)){
                return group;
            }
        }
        return null;
    }

    private void loadGroups(UserController userController) throws ParseException {
        User user = userController.getUserLoggedIn();
        ParseQuery<ParseObject> query = ParseQuery.getQuery("Group");
        query.whereEqualTo("groupadmin", user.getUsername());
        query.addAscendingOrder("Group");
        List<ParseObject> groupRetrieved = query.find();
        if (groupRetrieved != null) {
            for (ParseObject retrieve : groupRetrieved) {
                String groupName = retrieve.getString("groupname");
                String[] allMemberString = retrieve.getString("members").split(",");
                ArrayList<User> groupMembers = new ArrayList<User>();
                for (int i = 0; i < allMemberString.length; i++) {
                    String memberString = allMemberString[i].trim();
                    User retrievedUser = userController.getUserByUsername(memberString);
                    if (retrievedUser != null) {
                        groupMembers.add(retrievedUser);
                    }
                }
                ArrayList<String> emails = new ArrayList<String>();
                String emailString = retrieve.getString("emails").trim();
                if (!emailString.isEmpty()){
                    String[] emailArr = emailString.split(",");
                    emails.addAll(Arrays.asList(emailArr));
                }
                Group newGroup = new Group(groupName, user, groupMembers, emails, retrieve.getObjectId());
                groupMap.put(groupName, newGroup);
            }
        }
    }

    public HashMap<String, Group> getGroupMap() {
        return groupMap;
    }

    public void addGroupMember(Group group, User user) throws ParseException {
        group.addMember(user);
    }

    public void removeGroupMember(Group group, User user) throws ParseException {
        group.removeMember(user);
        if (group.getMembers().isEmpty()) {
            groupMap.remove(group.getGroupName());
            ParseQuery<ParseObject> query = ParseQuery.getQuery("Group");
            query.whereEqualTo("groupname", group.getGroupName());
            query.whereEqualTo("groupadmin", group.getGroupAdmin());
            ParseObject groupEntry = query.find().get(0);
            groupEntry.deleteInBackground();
        }
    }

    public void createGroup(String groupName, User user, ArrayList<User> members, ArrayList<String> emails) throws ParseException {
        Group group = new Group(groupName, user, members, emails, "");
        groupMap.put(groupName, group);
        group.save();
    }

    public void deleteGroup(Group group) throws ParseException {
        groupMap.remove(group.getGroupName());
        ParseQuery<ParseObject> query = ParseQuery.getQuery("Group");
        query.whereEqualTo("groupname", group.getGroupName());
        query.whereEqualTo("groupadmin", group.getGroupAdmin().getUsername());
        List<ParseObject> resultList = query.find();
        ParseObject groupEntry = null;
        try {
            if (resultList != null || !resultList.isEmpty()){
                groupEntry = resultList.get(0);
                groupEntry.deleteInBackground();
            }
        } catch (NullPointerException e){
            return;
        }
    }
    
    public void updateGroup(String oldGroupName, String newGroupName, ArrayList<User> members, ArrayList<String> emails) throws ParseException{
        Group group = groupMap.get(oldGroupName);
        groupMap.remove(oldGroupName);
        deleteGroup(group);
        groupMap.put(newGroupName, group);
        group.setGroupName(newGroupName);
        group.setGroupMembers(members);
        group.setEmails(emails);
        group.save();
    }
}