package controllers;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import models.Album;
import models.AlbumManager;
import models.Group;
import models.User;
import org.parse4j.ParseException;

public class AlbumController {
    
    private AlbumManager albumManager = null;
    
    public AlbumController(UserController userController) throws ParseException{
        albumManager = new AlbumManager(userController);
    }
    
    public ArrayList<Album> getAlbumList(){
        return albumManager.getAlbumList();
    }
    
    public ArrayList<Album> getTaggedAlbumsList(User user){
        return albumManager.getTaggedAlbumList(user);
    }
    
    public String addToAlbums(String[] albums, String[] photos, String[] photoLinks, User user) throws ParseException{
        return albumManager.addToAlbums(albums, photos, photoLinks, user);
    }
    
    public String createNewAlbum(String albumName, User user) throws ParseException{
        return albumManager.createNewAlbum(albumName, user);
    }
    
    public Album getAlbumByID(String albumID){
        return albumManager.getAlbumByID(albumID);
    }
    
    public Album getAlbumByAlbumName(String albumName, User user){
        return albumManager.getAlbumByAlbumName(albumName, user);
    }
    
    public void deleteAlbum(String albumID) throws ParseException{
        albumManager.deleteAlbum(albumID);
    }
    
    public void tagAlbum(Album album, ArrayList<Group> groups, User user, AppController appController) throws ParseException, AddressException, FileNotFoundException, IOException, MessagingException{
        albumManager.tagAlbum(album, groups, user, appController);
    }
    
    public void removeTag(Album album, User user) throws ParseException{
        albumManager.removeTag(album, user);
    }
}
