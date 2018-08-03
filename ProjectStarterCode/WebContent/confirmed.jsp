<%--
	Document : checkout
	Author   : Mhairi McDonald
--%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import ="util.BasketHandler" %>
<%@ page import ="java.sql.ResultSet" %>
<%@ page import ="java.util.Date" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
	rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>RentATree | Checkout</title>
</head>
<body>
	<%@include file="WEB-INF/jsp/navbar.jsp"%>
	
	<div class="container">
	<h1>Thank you!</h1>
	<h4><em>Your order is confirmed. We've sent you a confirmation email at <%=session.getAttribute("username") %></em></h4>
	<h5>Here's a summary of your order:</h5>
		<div class="row">
			<div class="col-md-12">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h4 class="panel-title">Order summary</h4>
					</div>
					<div class="panel-body">
						<div class="table-responsive">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Description</th>
                  <th>Material</th>
                  <th>Lease Duration</th>
                  <th>Quantity</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
          <%
          ResultSet rs = BasketHandler.getItemsFromBasket();
          double totalCost = 0;
          
          
          while(rs.next()){
        	  Date lStart = new java.util.Date(rs.getDate("LeaseStart").getTime());
              Date lEnd = new java.util.Date(rs.getDate("LeaseEnd").getTime());
              long diffInMillies = (long)lEnd.getTime() - (long)lStart.getTime();
              int diffInDays = (int) (diffInMillies / (1000 * 60 * 60 * 24));
              System.out.println(diffInDays);
        	  totalCost+= rs.getInt("PricePerDay") * diffInDays * rs.getInt("Quantity");
        	  %>
        	   <tr class="prod p<%= rs.getInt("ProductId") %>">
        	   	  <td><%=rs.getString("TreeType") %></td>
	        	  <td><%=rs.getString("Description") %></td>
	        	  <td><%=rs.getString("Material") %></td>
	        	  <td><%=diffInDays %></td>
	        	  <td><%=rs.getInt("Quantity") %></td>
	        	  <td></td>
	        	  
<%
          }
          double deposit = totalCost / 10;
%>			
			
          <tr class="bottom-line">
	        	<td></td>
	        	<td></td>
	        	<td></td>
	        	<td></td>
	        	<td><strong>Order total:</strong></td>
	        	<td><strong>&pound<%=totalCost += deposit %></strong></td>
	        	<td></td>
	        </tr>

          </tbody>
            </table>
					</div>
				</div>
			</div>
		</div>
	</div>
		<div class="row">
			<a href="index.jsp"><button class="btn btn-default">Return Home</button></a>
		</div>
	</div>
</body>
</html>