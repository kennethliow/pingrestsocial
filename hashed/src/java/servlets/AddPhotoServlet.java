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

public class AddPhotoServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        AppController appController = (AppController)session.getAttribute("appController");
        AlbumController albumController = appController.getAlbumController();
        UserController userController = appController.getUserController();
        if ((request.getParameter("photoIDs").isEmpty()) || (request.getParameter("photoLinks").isEmpty())){
            session.setAttribute("error", "Please select at least one photo to add");
            response.sendRedirect("explore.jsp");
            return;
        }
        if (request.getParameter("albums").isEmpty()) {
            session.setAttribute("error", "Please select at least one album to add into");
            response.sendRedirect("explore.jsp");
            return;
        }
        String[] photos_selected = request.getParameter("photoIDs").trim().split(",");
        String[] photos_selected_links = request.getParameter("photoLinks").trim().split(",");
        String[] albums_selected = request.getParameterValues("albums");
        
        String albumID = "";
        try {
            albumID = albumController.addToAlbums(albums_selected, photos_selected, photos_selected_links, userController.getUserLoggedIn());
        } catch (ParseException ex) {
            ex.printStackTrace();
        }
        session.setAttribute("success", "You have successfully added photos to your albums");
        if (albumID.equals("0")){
            response.sendRedirect("./albums.jsp");
        } else {
            response.sendRedirect("./album.jsp?id=" + albumID);
        }
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