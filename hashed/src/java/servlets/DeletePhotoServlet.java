package servlets;

import controllers.AlbumController;
import controllers.AppController;
import controllers.UserController;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import models.Album;
import org.parse4j.ParseException;

public class DeletePhotoServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        AppController appController = (AppController)session.getAttribute("appController");
        AlbumController albumController = appController.getAlbumController();
        UserController userController = appController.getUserController();
        String photoLinksStr = request.getParameter("photoLinks");
        String albumID = request.getParameter("albumID");
        Album album = albumController.getAlbumByID(albumID);
        String[] photoLinks = photoLinksStr.split(",");
        for (String photoLink : photoLinks){
            album.removePhotosWithPhotoLink(photoLink.trim());
        }
        try {
            album.save(userController.getUserLoggedIn());
        } catch (ParseException ex) {
        }
        String message = "You have successfully deleted the photos.";
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
