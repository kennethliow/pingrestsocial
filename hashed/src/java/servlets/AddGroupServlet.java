package servlets;

import controllers.AppController;
import controllers.UserController;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import models.Group;
import models.User;
import org.apache.commons.validator.routines.EmailValidator;
import org.parse4j.ParseException;

public class AddGroupServlet extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        String groupName = request.getParameter("groupName");
        AppController appController = (AppController) session.getAttribute("appController");
        UserController userController = appController.getUserController();
        Group group = userController.getGroupByGroupName(groupName);
        if (group != null){
            String message = "This group name has already been used, please try entering another group name!";
            session.setAttribute("error", message);
            response.sendRedirect("./groups.jsp");
            return;
        }
        String[] groupMembers = request.getParameter("processedGroupMembers").split(",");
        ArrayList<User> members = new ArrayList<User>();
        ArrayList<String> emails = new ArrayList<String>();
        ArrayList<String> rejected = new ArrayList<String>();
        for (String groupMember : groupMembers){
            User user = userController.getUserByUsername(groupMember);
            if (user == null){
                EmailValidator emailValidator = EmailValidator.getInstance();
                if (emailValidator.isValid(groupMember)){
                    emails.add(groupMember);
                } else {
                    rejected.add(groupMember);
                }
            } else {
                members.add(user);
            }
        }
        try {
            userController.createGroup(groupName, userController.getUserLoggedIn(), members, emails);
        } catch (ParseException ex) {
        }
        String albumID = request.getParameter("albumID");
        if (albumID != null && !albumID.isEmpty()){
            RequestDispatcher rd = request.getRequestDispatcher("/TagUsersServlet?albumID=" + albumID + "&groups=" + groupName);
            rd.forward(request, response);
            return;
        }
        if (rejected.isEmpty()){
            String message = "You have successfully created the group!";
            session.setAttribute("success", message);
            response.sendRedirect("./groups.jsp");
            return;
        } else {
            String message = "You have successfully created the group! However, there following names have been rejected:";
            for (String reject : rejected){
                message += "<br>" + reject;
            }
            session.setAttribute("warning", message);
            response.sendRedirect("./groups.jsp");
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