package servlets;

import controllers.AppController;
import controllers.UserController;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import models.Group;
import models.User;
import org.apache.commons.validator.routines.EmailValidator;
import org.parse4j.ParseException;

public class UpdateGroupServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        AppController appController = (AppController) session.getAttribute("appController");
        UserController userController = appController.getUserController();
        String oldGroupName = request.getParameter("oldGroupName");
        String newGroupName = request.getParameter("newGroupName").trim();
        Group group = userController.getGroupByGroupName(newGroupName);
        if (group != null && !oldGroupName.equals(newGroupName)) {
            String message = "This group name has already been used, please try entering another group name!";
            session.setAttribute("error", message);
            response.sendRedirect("./groups.jsp");
            return;
        }
        String[] groupMembers = request.getParameter("groupMembers").split(",");
        ArrayList<User> members = new ArrayList<User>();
        ArrayList<String> emails = new ArrayList<String> ();
        for (String groupMember : groupMembers) {
            User user = userController.getUserByUsername(groupMember.trim());
            if (user != null) {
                members.add(user);
            } else {
                EmailValidator emailValidator = EmailValidator.getInstance();
                if (emailValidator.isValid(groupMember)) {
                    emails.add(groupMember);
                }
            }
        }
        try {
            userController.updateGroup(oldGroupName, newGroupName, members, emails);
        } catch (ParseException e) {
        }

        String message = "You have successfully made changes to the group!";
        session.setAttribute("success", message);
        response.sendRedirect("./groups.jsp");
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