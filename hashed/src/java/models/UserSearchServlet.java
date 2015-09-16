package models;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class UserSearchServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // preparing parameters
        HttpSession session = request.getSession();
        String accessToken = (String) session.getAttribute("access_token");
        String username = request.getParameter("username");
        String urlString = "https://api.instagram.com/v1/users/search?q=" + username + "&access_token=" + accessToken;
        
        // firing request to get instagram user details
        URL url = new URL(urlString); 
        HttpURLConnection urlcon = (HttpURLConnection) url.openConnection();
        urlcon.setRequestMethod("GET");
        urlcon.setRequestProperty("Content-Type", "application/json");

        // get the input from the request
        BufferedReader in = new BufferedReader(new InputStreamReader(urlcon.getInputStream()));
        String jsonResponse = in.readLine();
        in.close();
        
        // parsing json data from instagram
        JSONObject retrievedObject = (JSONObject) JSONValue.parse(jsonResponse);
        JSONObject firstDataObject = (JSONObject) ((JSONArray) retrievedObject.get("data")).get(0);
        String userID = firstDataObject.get("id").toString();
        
        // forwarding to image search servlet
        request.setAttribute("userID", userID);
        RequestDispatcher rd = request.getRequestDispatcher("/ImageSearchServlet");
        rd.forward(request, response);
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
