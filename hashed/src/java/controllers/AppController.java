package controllers;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Properties;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.servlet.ServletContext;
import org.parse4j.Parse;
import org.parse4j.ParseException;

public class AppController {

    private String appPath;
    //email settings
    private String emailSenderEmail;
    private String emailPassword;
    private Properties emailSystemProperties;
    private final Session emailSession;
    private ServletContext servletContext;
    private AlbumController albumController;
    private final UserController userController;
    private HashMap <String, Thread> threadMap;
    private final PostController postController;

    public AppController(String path, ServletContext context, UserController userController) throws ParseException {
        Parse.initialize("P0CrqeHC9sOY0qNzO1Gl9NZfbVPlIGSvhvAc4c9N", "pors7XxI3oWEHwARoKLkXJmROmFZorbq8zL5cuyH");
        appPath = path;
        servletContext = context;
        emailSenderEmail = "hashedweb@gmail.com";
        emailPassword = "geraldcodeall";
        emailSystemProperties = new Properties();
        emailSystemProperties.put("mail.smtp.starttls.enable", "true");
        emailSystemProperties.put("mail.smtp.host", "smtp.gmail.com");
        emailSystemProperties.put("mail.smtp.port", "587");
        emailSystemProperties.put("mail.smtp.auth", "true");
        emailSession = Session.getInstance(emailSystemProperties, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(emailSenderEmail, emailPassword);
            }
        });
        albumController = new AlbumController(userController);
        this.userController = userController;  
        postController = new PostController();
        threadMap = new HashMap <String, Thread> ();
    }

    public String getAppPath() {
        return appPath;
    }

    public String getEmailSender() {
        return emailSenderEmail;
    }

    public Properties getEmailSystemProperties() {
        return emailSystemProperties;
    }

    public Session getEmailSession() {
        return emailSession;
    }
    
    public ServletContext getServletContext(){
        return servletContext;
    }
    
    public AlbumController getAlbumController(){
        return albumController;
    }
    
    public UserController getUserController(){
        return userController;
    }
    
    public PostController getPostController(){
        return postController;
    }
    
    public void reinitialise() throws ParseException {
        albumController = new AlbumController(userController);
    }
    
    public void addThreadToMap(String name, Thread thread) {
        threadMap.put(name, thread);
    }
    
    public Thread getThreadByName(String name){
        return threadMap.get(name);
    }
    
    public void killThreads(){
        ArrayList <Thread> threads = new ArrayList <Thread> ();
        threads.addAll(threadMap.values());
        for (Thread thread : threads){
            thread.interrupt();
        }
    }
}
