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
import models.User;
import org.parse4j.ParseException;

public class AddAlbumServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String albumName = request.getParameter("album_name");
        HttpSession session = request.getSession();
        if (albumName.isEmpty()) {
            session.setAttribute("error", "Please enter a name for your new album!");
            response.sendRedirect("albums.jsp");
            return;
        }
        String albumID = null;
        AppController appController = (AppController)session.getAttribute("appController");
        AlbumController albumController = appController.getAlbumController();
        UserController userController = appController.getUserController();
        User user = userController.getUserLoggedIn();
        Album album = albumController.getAlbumByAlbumName(albumName, user);
        if (album != null){
            session.setAttribute("error", "This album name has been used! Please choose a new album name!");
            response.sendRedirect("albums.jsp");
            return;
        }
        try {
            albumID = albumController.createNewAlbum(albumName, user);
        } catch (ParseException e){
        }
        if (!(request.getParameter("photoIDs").isEmpty())){
            request.getRequestDispatcher("/AddPhotoServlet?albums=" + albumName).forward(request, response);
            return;
        }
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