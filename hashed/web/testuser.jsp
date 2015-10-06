<%if (session.getAttribute("pass")==null || (Integer)session.getAttribute("pass")!=123456){
    response.sendRedirect("index.jsp");
}%>