package servlets;

import controllers.AlbumController;
import controllers.AppController;
import controllers.UserController;
import java.io.IOException;
import java.util.ArrayList;
import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import models.Album;
import models.Group;
import org.parse4j.ParseException;

public class TagUsersServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        AppController appController = (AppController) session.getAttribute("appController");
        UserController userController = appController.getUserController();
        AlbumController albumController = appController.getAlbumController();
        String albumID = request.getParameter("albumID");
        String[] groupNames = request.getParameterValues("groups");
        if (groupNames.length == 0) {
            String message = "Please select at least one group to tag";
            session.setAttribute("error", message);
            response.sendRedirect("./album.jsp?id=" + albumID);
            return;
        }
        ArrayList<Group> groups = new ArrayList<Group>();
        for (String groupName : groupNames) {
             Group group = userController.getGroupByGroupName(groupName);
             groups.add(group);
        }
        Album album = albumController.getAlbumByID(albumID);
        try {
            albumController.tagAlbum(album, groups, userController.getUserLoggedIn(), appController);
        } catch (ParseException ex) {
            ex.printStackTrace();
        } catch (MessagingException ex) {
            ex.printStackTrace();
        } 
        String message = "You have successfully tagged the album";
        session.setAttribute("success", message);
        response.sendRedirect("./album.jsp?id=" + albumID);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}