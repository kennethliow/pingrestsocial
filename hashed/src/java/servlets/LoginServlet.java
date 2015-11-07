package servlets;

import controllers.AppController;
import controllers.UserController;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.parse4j.ParseException;
import java.util.*;

public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accessToken = "454859018.89c8fdb.145d2bd0d74b4e0da0893a5cab992523";
        HttpSession session = request.getSession();
        
        session.setAttribute("access_token", accessToken);
        
        HashMap<String,String> users = new HashMap<String,String>();
        users.put("pingadmin", "abc12345");
        users.put("ken", "123");
        
        String user = (String) request.getParameter("username");
        String pw = (String)request.getParameter("password");
        
        String pwTest = users.get(user);
        if(pwTest==null || !pwTest.equals(pw)) {
            session.setAttribute("fail", "Wrong Username/Password");
            response.sendRedirect("./index.jsp");
        } else {
            session.removeAttribute("fail");
            session.setAttribute("pass", 123456);
            response.sendRedirect("./is434.jsp");
        }
        
        
        
        /*
        String error = request.getParameter("error");
        if (error != null) {
            response.sendRedirect("./index.jsp");
            return;
        }
        String clientID = "";
        String clientSecret = "";
        String redirectURI = "";
        
        String environment = (String) session.getAttribute("environment");
        if (environment.equals("development")){
            clientID = "ae09aaad138048e9a144317336a003f7";
            clientSecret = "023314c80a0c4d3ea946624bada31c7c";
            redirectURI = "http://localhost:8084/hashed/LoginServlet";
        } else {
            clientID = "bb635ec0a55d4a8e8c24b858e6e60a75";
            clientSecret = "b2f8627da1ab49fa85c60005e53f5b72";
            redirectURI = "http://hashed-g2t9.rhcloud.com/LoginServlet";
        }
        
       
        String code = request.getParameter("code");
        String currentURL = request.getRequestURL().toString();
        String webAppPath = currentURL.substring(0, currentURL.lastIndexOf("/"));
        
        String urlParameters = "client_id=" + URLEncoder.encode(clientID, "UTF-8") + "&client_secret=" + URLEncoder.encode(clientSecret, "UTF-8") + "&grant_type=" + URLEncoder.encode("authorization_code", "UTF-8") + "&redirect_uri=" + URLEncoder.encode(redirectURI, "UTF-8") + "&code=" + URLEncoder.encode(code, "UTF-8");

        URL secondAuth = new URL("https://api.instagram.com/oauth/access_token");
        HttpURLConnection urlcon = (HttpURLConnection) secondAuth.openConnection();
        urlcon.setDoOutput(true);
        urlcon.setDoInput(true);
        urlcon.setRequestProperty("Content-Type", "application/json");
        urlcon.setUseCaches(false);
        
        // send request
        DataOutputStream cgiInput = new DataOutputStream(urlcon.getOutputStream());
	cgiInput.writeBytes(urlParameters);
	cgiInput.flush();
	cgiInput.close();
        
        // get the input from the request
        BufferedReader in = new BufferedReader(new InputStreamReader(urlcon.getInputStream()));
        String res = in.readLine();
        in.close();

        // retrieving response
        Object obj = JSONValue.parse(res);
        JSONObject jObj = (JSONObject) obj;
        String accessToken = (String) jObj.get("access_token");
        session.setAttribute("access_token", accessToken);
        JSONObject jDataObj = (JSONObject) jObj.get("user");

        String id = (String) jDataObj.get("id");
        String profilePicture = (String) jDataObj.get("profile_picture");
        String username = (String) jDataObj.get("username");
        String fullname = (String) jDataObj.get("full_name");
        UserController userController = null;
        try {
            userController = new UserController(id, username, fullname, profilePicture);
            AppController appController = null;
            try {
                appController = new AppController(webAppPath, request.getServletContext().getContext("/hashed"), userController);
            } catch (ParseException e) {
                e.printStackTrace();
                System.exit(0);
            }
            session.setAttribute("appController", appController);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
        //creating cookies
        Cookie cookie = new Cookie(id, "");
        cookie.setMaxAge(86400000);
        response.addCookie(cookie);
        
        session.setAttribute("user", userController.getUserLoggedIn());
        
        // if user is logged in from shared email
        if (session.getAttribute("newAlbumID") != null && session.getAttribute("newGroupID") != null && session.getAttribute("verificationCode") != null && userController.getUserLoggedIn().getEmail().isEmpty()) {
            RequestDispatcher rd = request.getRequestDispatcher("/LinkEmailToUserServlet");
            rd.forward(request, response);
            return;
        } else {
            response.sendRedirect("./explore.jsp");
        }
        */
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
