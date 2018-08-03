<%--
	Document : login
	Author   : Mhairi McDonald
--%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="model.Session" %>
<%@ page import="model.Account" %>
<%@ page import="model.Admin" %>
<%@ page import="util.BasketHandler" %>

    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>RentATree | Login To Your Account</title>
</head>
<body>

<%
	Session s = new Session();

	try{
		String username = request.getParameter("username");
		String password=request.getParameter("password");
		if(username!=null && password!=null){
			boolean isSuccess = s.login(username, password);
			if(isSuccess){
				Account accountType = Session.getAccount();
				session.setAttribute("username", username);
				response.sendRedirect("index.jsp");
	 			if(accountType instanceof Account){
	 				response.sendRedirect("index.jsp");
	 			} else if(accountType instanceof Admin) {
	 				response.sendRedirect("admin.jsp");
	 			} 
			} else {
				out.println("Incorrect details");
			}
		}
		
	} catch(Exception e){
		out.println("Something went wrong, please try again");
	}
%>
</body>
</html>