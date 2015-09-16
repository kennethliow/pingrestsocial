package models;

import controllers.AppController;
import controllers.UserController;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import org.parse4j.ParseException;
import org.parse4j.ParseObject;
import org.parse4j.ParseQuery;

public class AlbumManager {

    ArrayList<Album> albumList;

    public AlbumManager(UserController userController) throws ParseException {
        albumList = new ArrayList<Album>();
        loadAlbums(userController);
        loadTaggedAlbums(userController);
    }

    public ArrayList<Album> getAlbumList() {
        return albumList;
    }

    public ArrayList<Album> getTaggedAlbumList(User user) {
        ArrayList<Album> returningList = new ArrayList<Album>();
        for (Album album : albumList) {
            if (album.getOwner() != user) {
                returningList.add(album);
            }
        }
        return returningList;
    }

    public Album getAlbum(String name, User user) {
        for (Album album : albumList) {
            if (album.getName().equals(name) && album.getOwner() == user) {
                return album;
            }
        }
        return null;
    }

    public Album getAlbumByID(String albumID) {
        for (Album album : albumList) {
            if (album.getAlbumID().equals(albumID)) {
                return album;
            }
        }
        return null;
    }

    public Album getAlbumByAlbumName(String albumName, User user) {
        for (Album album : albumList) {
            if (album.getName().equals(albumName) && album.getOwner() == user) {
                return album;
            }
        }
        return null;
    }

    public String createNewAlbum(String albumName, User user) throws ParseException {
        Album album = new Album(albumName, user);
        albumList.add(album);
        return album.save(user);
    }

    public String addToAlbums(String[] albums, String[] photos, String[] photoLinks, User user) throws ParseException {
        String oneAlbumLocation = "";
        for (String albumName : albums) {
            Album album = getAlbum(albumName, user);
            if (album != null) {
                for (int i = 0; i < photos.length; i++) {
                    String photoID = photos[i];
                    String photoLink = photoLinks[i];
                    album.addPhoto(photoID, photoLink);
                }
                oneAlbumLocation = album.save(user);
            }
        }
        if (albums.length == 1) {
            return oneAlbumLocation;
        } else {
            return "0";
        }
    }

    public void deleteAlbum(String albumID) throws ParseException {
        Album album = getAlbumByID(albumID);
        albumList.remove(album);
        ParseQuery<ParseObject> query = ParseQuery.getQuery("Album");
        query.whereEqualTo("objectId", albumID);
        ParseObject albumRetrieved = query.find().get(0);
        albumRetrieved.delete();
    }

    public void tagAlbum(Album album, ArrayList<Group> groups, User user, AppController appController) throws ParseException, AddressException, FileNotFoundException, IOException, MessagingException {
        ArrayList<User> users = album.getTaggedUsers();
        ArrayList<String> currentEmails = album.getTaggedEmails();
        for (Group group : groups) {
            ArrayList<User> members = group.getMembers();
            for (User member : members) {
                if (!users.contains(member) && !member.equals(user)) {
                    users.add(member);
                }
            }
            ArrayList<String> emails = group.getEmails();
            if (!emails.isEmpty()){
                for (String email : emails) {
                    boolean alreadyExist = false;
                    for (String currentEmail : currentEmails) {
                        if (currentEmail.equals(email)) {
                            alreadyExist = true;
                        }
                    }
                    if (!alreadyExist) {
                        currentEmails.add(email);
                    }
                }
                tagAlbumViaEmail(album, emails, group, appController);
            }
        }
        album.setTaggedUsers(users);
        album.setTaggedEmails(currentEmails);
        album.save(user);
    }

    public void tagAlbumViaEmail(Album album, ArrayList<String> emails, Group group, AppController appController) throws AddressException, FileNotFoundException, IOException, MessagingException {
        String emailer = "";
        InputStream is = appController.getServletContext().getResourceAsStream("./emailer.jsp");
        BufferedReader br = null;
        StringBuilder sb = new StringBuilder();
        br = new BufferedReader(new InputStreamReader(is));
        while ((emailer = br.readLine()) != null) {
            sb.append(emailer);
        }
        if (br != null) {
            br.close();
        }
        emailer = sb.toString();
        for (String email : emails) {
            Thread thread = new Thread(new EmailSenderRunnable(email, emailer, appController, album, group));
            thread.start();
        }
    }

    public void removeTag(Album album, User user) throws ParseException {
        String username = user.getUsername();
        ArrayList<User> users = album.getTaggedUsers();
        Iterator iter = users.iterator();
        while (iter.hasNext()) {
            User retrievedUser = (User) iter.next();
            if (retrievedUser.getUsername().equals(username)) {
                iter.remove();
            }
        }
        album.setTaggedUsers(users);
        album.save(user); 
    }

    private void loadAlbums(UserController userController) throws ParseException {
        User user = userController.getUserLoggedIn();
        ParseQuery<ParseObject> query = ParseQuery.getQuery("Album");
        query.whereEqualTo("userid", user.getUserID());
        query.addAscendingOrder("Album");
        List<ParseObject> albumsRetrieved = query.find();
        if (albumsRetrieved != null) {
            for (ParseObject retrieve : albumsRetrieved) {
                String albumName = retrieve.getString("albumname");
                String retrieved_mediaid = retrieve.getString("mediaid");
                ArrayList<String> mediaIDs = null;
                if (retrieved_mediaid.isEmpty()) {
                    mediaIDs = new ArrayList<String>();
                } else {
                    mediaIDs = new ArrayList<String>(Arrays.asList(retrieved_mediaid.split(",")));
                }
                String retrieved_photo_links = retrieve.getString("photolinks");
                ArrayList<String> photoLinks = null;
                if (retrieved_photo_links.isEmpty()) {
                    photoLinks = new ArrayList<String>();
                } else {
                    photoLinks = new ArrayList<String>(Arrays.asList(retrieved_photo_links.split(",")));
                }
                String coverArt = retrieve.getString("cover_art");
                String taggedUsersString = retrieve.getString("tagged_users");
                ArrayList<User> taggedUsers = new ArrayList<User>();
                if (!taggedUsersString.isEmpty()) {
                    String[] taggedUsersArr = taggedUsersString.split(",");
                    for (String taggedUserString : taggedUsersArr) {
                        User taggedUser = userController.getUserByUsername(taggedUserString);
                        taggedUsers.add(taggedUser);
                    }
                }
                String taggedEmailString = retrieve.getString("tagged_emails");
                ArrayList<String> tagged_emails = new ArrayList<String>();
                if (!taggedEmailString.isEmpty()) {
                    tagged_emails = new ArrayList<String>(Arrays.asList(taggedEmailString.split(",")));
                }
                Album album = new Album(albumName, mediaIDs, photoLinks, user, coverArt, "", retrieve.getObjectId(), taggedUsers, tagged_emails);
                albumList.add(album);
            }
        }
    }

    public void loadTaggedAlbums(UserController userController) throws ParseException {
        User user = userController.getUserLoggedIn();
        ParseQuery<ParseObject> query = ParseQuery.getQuery("Album");
        query.whereContains("tagged_users", user.getUsername());
        query.addAscendingOrder("Album");
        List<ParseObject> albumsRetrieved = query.find();
        if (albumsRetrieved != null) {
            for (ParseObject retrieve : albumsRetrieved) {
                String albumName = retrieve.getString("albumname");
                String retrieved_mediaid = retrieve.getString("mediaid");
                ArrayList<String> mediaIDs = null;
                if (retrieved_mediaid.isEmpty()) {
                    mediaIDs = new ArrayList<String>();
                } else {
                    mediaIDs = new ArrayList<String>(Arrays.asList(retrieved_mediaid.split(",")));
                }
                String ownername = retrieve.getString("username");
                User retrievedUser = userController.getUserByUsername(ownername);
                String retrieved_photo_links = retrieve.getString("photolinks");
                ArrayList<String> photoLinks = null;
                if (retrieved_photo_links.isEmpty()) {
                    photoLinks = new ArrayList<String>();
                } else {
                    photoLinks = new ArrayList<String>(Arrays.asList(retrieved_photo_links.split(",")));
                }
                String coverArt = retrieve.getString("cover_art");
                String taggedUsersString = retrieve.getString("tagged_users");
                ArrayList<User> taggedUsers = new ArrayList<User>();
                if (!taggedUsersString.isEmpty()) {
                    String[] taggedUsersArr = taggedUsersString.split(",");
                    for (String taggedUserString : taggedUsersArr) {
                        User taggedUser = userController.getUserByUsername(taggedUserString);
                        taggedUsers.add(taggedUser);
                    }
                }
                String taggedEmailString = retrieve.getString("tagged_emails");
                ArrayList<String> tagged_emails = new ArrayList<String>();
                if (!taggedEmailString.isEmpty()) {
                    tagged_emails = new ArrayList<String>(Arrays.asList(taggedEmailString.split(",")));
                }
                Album album = new Album(albumName, mediaIDs, photoLinks, retrievedUser, coverArt, "", retrieve.getObjectId(), taggedUsers, tagged_emails);
                albumList.add(album);
            }
        }
    }
}