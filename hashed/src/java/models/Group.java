package models;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import org.parse4j.ParseException;
import org.parse4j.ParseObject;
import org.parse4j.ParseQuery;

public class Group {

    private String groupName;
    private User groupAdmin;
    private ArrayList<User> members;
    private ArrayList<String> emails;
    private String groupID;

    public Group(String groupName, User groupAdmin, ArrayList<User> members, ArrayList<String> emails, String groupID) {
        this.groupName = groupName;
        this.groupAdmin = groupAdmin;
        this.members = members;
        this.emails = emails;
        this.groupID = groupID;
    }

    public ArrayList<User> getMembers() {
        return members;
    }
    
    public ArrayList<String> getEmails(){
        return emails;
    }

    public String getGroupName() {
        return groupName;
    }

    public User getGroupAdmin() {
        return groupAdmin;
    }
    
    public String getGroupID(){
        return groupID;
    }

    public void addMember(User user) throws ParseException {
        members.add(user);
        save();
    }
    
    public void setGroupName(String groupName){
        this.groupName = groupName;
    }
    
    public void setGroupMembers(ArrayList <User> members){
        this.members = members;
    }
    
    public void setEmails(ArrayList<String> emails){
        this.emails = emails;
    }

    public void removeMember(User userToRemove) throws ParseException {
        Iterator iter = members.iterator();
        while (iter.hasNext()) {
            User user = (User) iter.next();
            if (user == userToRemove) {
                iter.remove();
                save();
            }
        }
    }
    
    public void removeEmail(String email){
        emails.remove(email);
    }

    public void save() throws ParseException {
        ParseQuery<ParseObject> query = ParseQuery.getQuery("Group");
        query.whereEqualTo("groupname", groupName);
        query.whereEqualTo("groupadmin", groupAdmin.getUsername());
        List<ParseObject> result = query.find();
        ParseObject groupEntry = null;
        if (result != null){
            groupEntry = result.get(0);
        } else {
            groupEntry = new ParseObject("Group");
        }
        String compiledMembers = "";
        for (int i = 0; i < members.size(); i++) {
            User member = members.get(i);
            compiledMembers += member.getUsername();
            if (i != members.size() - 1) {
                compiledMembers += ",";
            }
        }
        String compiledEmails = "";
        for (int i = 0; i < emails.size(); i++) {
            String email = emails.get(i);
            compiledEmails += email;
            if (i != emails.size() - 1) {
                compiledEmails += ",";
            }
        }
        groupEntry.put("members", compiledMembers);
        groupEntry.put("groupadmin", groupAdmin.getUsername());
        groupEntry.put("groupname", groupName);
        groupEntry.put("emails", compiledEmails);
        groupEntry.save();
        groupID = groupEntry.getObjectId();
    }
}