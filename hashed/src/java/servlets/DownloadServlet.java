package servlets;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.URL;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DownloadServlet extends HttpServlet {

    public final static int SOCKET_PORT = 13267;
    ServerSocket servsock = null;
    Socket sock = null;
    OutputStream os = null;
    BufferedInputStream bis = null;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        ServletOutputStream fos;
        try {
            //servsock = new ServerSocket(SOCKET_PORT);
            //	sock = servsock.accept();

            //String accessToken = (String)session.getAttribute("access_token");
            String imagelinks = request.getParameter("imagelinks");
            imagelinks = imagelinks.substring(1, imagelinks.length() - 1);
            //after getting the image links convert to arraylist by split.
            String[] imageLinks = imagelinks.split(",");
            //change this according to the route that you have.
            //still unable to prompt for download

            // FileOutputStream fos = new FileOutputStream("/Users/IITSLoan/Downloads/images.zip");
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            //ZipOutputStream zos = new ZipOutputStream(baos); 
            zout = new ZipOutputStream(baos);
            //do a for loook of the image links
            for (int i = 0; i < imageLinks.length; i++) {
                String imagelink = imageLinks[i];
                try {
                    byte[] buf = new byte[1024];
                    addToZip_Image(buf, imagelink, i);
                } catch (Exception e) {
                }

            }
            zout.flush();
            baos.flush();
            zout.close();
            baos.close();
            response.setContentType("application/zip");
            response.setHeader("Content-Disposition", "attachment ; filename=image.zip");
            fos = response.getOutputStream();
            byte[] zip = baos.toByteArray();
            fos.write(zip);
            fos.flush();
            fos.close();
        } catch (Exception e) {
        }
        // response.sendRedirect("/share.html");
    }
    ZipOutputStream zout;

    public void addToZip_Image(byte[] buf, String file, int i) {
        try {
            InputStream input = new URL(file).openStream();
            BufferedInputStream bis = new BufferedInputStream(input);
            zout.putNextEntry(new ZipEntry(i + ".jpg"));

            int bytesRead;
            while ((bytesRead = bis.read(buf)) != -1) {
                zout.write(buf, 0, bytesRead);
            }

            zout.closeEntry();

            input.close();
            bis.close();
        } catch (Exception e) {
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
