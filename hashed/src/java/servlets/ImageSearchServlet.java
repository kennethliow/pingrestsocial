package servlets;

import controllers.AppController;
import controllers.PostController;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import models.Post;
import models.SearcherRunnable;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class ImageSearchServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        // setting parameters, default search mode is hashtag search
        HttpSession session = request.getSession();
        AppController appController = (AppController) session.getAttribute("appController");
        String term = request.getParameter("search_term");
        String accessToken = (String) session.getAttribute("access_token");
        String urlString = "https://api.instagram.com/v1/tags/" + term + "/media/recent?access_token=" + accessToken;
        PostController postController = appController.getPostController();
        
        // if user search
        if (request.getAttribute("userID") != null){
            String userID = request.getAttribute("userID").toString();
            urlString = "https://api.instagram.com/v1/users/" + userID + "/media/recent/?access_token=" + accessToken;
        }
        
        ArrayList <Post> images = new ArrayList <Post> ();
        
        // fetching from Instagram servers
        while (!(urlString != null && images.size() >= 100)){
            try {
                URL url = new URL(urlString); 
                HttpURLConnection urlcon = (HttpURLConnection) url.openConnection();
                urlcon.setRequestMethod("GET");
                urlcon.setRequestProperty("Content-Type", "application/json");

                // get the input from the request
                BufferedReader in = new BufferedReader(new InputStreamReader(urlcon.getInputStream()));
                String jsonResponse = in.readLine();
                in.close();

                // retrieving and parsing response
                JSONObject retrievedObject = (JSONObject) JSONValue.parse(jsonResponse);
                JSONArray dataArray = (JSONArray) retrievedObject.get("data");
                for (Object arrayObject : dataArray){
                    JSONObject dataObject = (JSONObject) arrayObject;
                    JSONArray tagsArray = (JSONArray) dataObject.get("tags");
                    ArrayList <String> tags = new ArrayList <String> ();
                    tags.addAll(tagsArray);
                    String type = (String) dataObject.get("type");
                    JSONObject locationObject = (JSONObject) dataObject.get("location");
                    String location = null;
                    if (locationObject != null){
                        location = locationObject.toString();
                    }
                    long likes = (Long) ((JSONObject) dataObject.get("likes")).get("count");
                    JSONObject imageObject = (JSONObject) ((JSONObject) dataObject.get("images")).get("standard_resolution");
                    String imageLink = imageObject.get("url").toString();
                    JSONArray taggedUsersArray = (JSONArray) dataObject.get("users_in_photo");
                    ArrayList <String> taggedUsers = new ArrayList <String> ();
                    for (Object taggedUserObject : taggedUsersArray){
                        JSONObject taggedUser = (JSONObject) taggedUserObject;
                        String taggedUsername = ((JSONObject) taggedUser.get("user")).get("username").toString();
                        taggedUsers.add(taggedUsername);
                    }
                    JSONObject captionObject = (JSONObject) dataObject.get("caption");
                    String caption = null;
                    if (captionObject != null){
                        caption = captionObject.get("text").toString();
                    }
                    String ID = (String) dataObject.get("id");
                    String user = (String) ((JSONObject) dataObject.get("user")).get("username");
                    
                    postController.add(term, tags, type, location, likes, imageLink, taggedUsers, caption, ID, user);
                }

                // preparing for subsequent rounds
                urlString = (String)((JSONObject) retrievedObject.get("pagination")).get("next_url");
                images = postController.getSearchResults(term);

            } catch (MalformedURLException ex) {
                Logger.getLogger(SearcherRunnable.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IOException ex) {
                Logger.getLogger(SearcherRunnable.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        // continuing search in background
        Thread thread = new Thread(new SearcherRunnable(term, accessToken, urlString, postController));
        thread.start();
        appController.addThreadToMap(term, thread);
        
        // preparing output
        out.println(JSONValue.toJSONString(images));
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
