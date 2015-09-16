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
import models.Group;
import models.User;
import models.Verification;
import org.parse4j.ParseException;

public class LinkEmailToUserServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        //preparing parameters
        HttpSession session = request.getSession();
        String albumID = (String) session.getAttribute("newAlbumID");
        String groupID = (String) session.getAttribute("newGroupID");
        String code = (String) session.getAttribute("verificationCode");
        User user = (User) session.getAttribute("user");
        AppController appController = (AppController) session.getAttribute("appController");
        AlbumController albumController = appController.getAlbumController();
        UserController userController = appController.getUserController();
        
        //removing used session attributes
        session.removeAttribute("newAlbumID");
        session.removeAttribute("newGroupID");
        session.removeAttribute("verificationCode");
        
        try {
            String email = Verification.verify(code);
            if (email != null){
                //replace email in album to user
                Album album = albumController.getAlbumByID(albumID);
                album.removeTaggedEmail(email);
                if (album.getOwner() != user){
                    album.addTaggedUser(user);
                }
                album.save(user);
                
                //replace email in groups to user
                Group group = userController.getGroupByID(groupID);
                group.removeEmail(email);
                if (group.getGroupAdmin() != user){
                    group.addMember(user);
                }
                group.save();
                
                //link user with email
                user.setEmail(email);
                user.save();
                
                //reinitialise controllers
                appController.reinitialise();
            }
        } catch (ParseException e){
            e.printStackTrace();
        }
        
        response.sendRedirect("./explore.jsp");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
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
     * Handles the HTTP <code>POST</code> method.
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
