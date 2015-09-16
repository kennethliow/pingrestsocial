package models;

import controllers.AppController;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import org.parse4j.ParseException;

public class EmailSenderRunnable implements Runnable {
    
    private final String email;
    private String content;
    private final AppController appController;
    private final Album album;
    private final Group group;
    
    public EmailSenderRunnable(String email, String content, AppController appController, Album album, Group group){
        this.email = email;
        this.content = content;
        this.appController = appController;
        this.album = album;
        this.group = group;
    }
    
    public void run() {
        try {
            String code = Verification.save(email);
            content = content.replaceAll("<!--Username-->", appController.getUserController().getUserLoggedIn().getUsername());
            content = content.replaceAll("<!--Albumlink-->", appController.getAppPath() + "/share.jsp?id=" + album.getAlbumID() + "&groupID=" + group.getGroupID() + "&code=" + code);
            MimeMessage message = new MimeMessage(appController.getEmailSession());
            message.setFrom(new InternetAddress(appController.getEmailSender()));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
            message.setSubject("You have been tagged!");
            message.setContent(content, "text/html; charset=utf-8");
            Transport.send(message);
        } catch (ParseException ex) {
            ex.printStackTrace();
        } catch (MessagingException ex){
            ex.printStackTrace();
        }
    }
}
