<%--
	Document : basket
	Author   : Mhairi McDonald
--%>

<%@ page language="java" contentType="text/html; charset=UTF8" pageEncoding="UTF8"%>
<%@ page import ="model.Product" %>
<%@ page import ="java.util.ArrayList" %>
<%@ page import ="util.BasketHandler" %>
<%@ page import ="model.BasketItem" %>
<%@ page import ="java.sql.ResultSet" %>
<%@ page import ="model.Session" %>
<%@ page import ="java.util.Date" %>


<!doctype html>
<html>
<head>
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" >
<link href="css/style.css" rel="stylesheet" >
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>RentATree | Your Basket</title>
</head>
<body>


    <%@include file="WEB-INF/jsp/navbar.jsp" %>

        <main class="col-sm-9 offset-sm-3 col-md-10 offset-md-2 pt-3">
          <h1>Basket</h1>
          In your basket is:
          <div class="table-responsive">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th>Product Id</th>
                  <th>Name</th>
                  <th>Material</th>
                  <th>Price Per Day</th>
                  <th>Lease Start</th>
                  <th>Lease End</th>
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
	        	  <td><%=rs.getInt("ProductId") %></td>
	        	  <td><%=rs.getString("TreeType") %></td>
	        	  <td><%=rs.getString("Material") %></td>
	        	  <td>&pound<%=rs.getInt("PricePerDay") %></td>
	        	  <td><%=rs.getDate("LeaseStart") %></td>
	        	  <td><%=rs.getDate("LeaseEnd") %></td>
	        	  <td><%=rs.getInt("Quantity") %></td>
	        	  <td><a href="/ProjectStarterCode/BasketHandler"></a><button class="btn btn-warning" type="button">Remove</button></td>
	     
	        </tr>
<%
          }
          double deposit = totalCost / 10;
          
%>				
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td><strong>Select collection type:</strong></td>
				<td><form action="checkout.jsp"><select name="collType" class="form-control">
					  <option>--Select--</option>
					  <option>Collection</option>
					  <option>Delivery</option>
					</select></form></td>
				<td></td>
			</tr>
			<tr>
			<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td><strong>Select collection slot:</strong>
				</td>
				<td><form action="checkout.jsp"><select name="collSlot" class="form-control">
					  <option>--Any--</option>
					  <option>AM</option>
					  <option>PM</option>
					</select></form></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td><strong>Select return type:</strong></td>
				<td><form action="checkout.jsp"><select name="returnType" class="form-control">
					  <option>--Select--</option>
					  <option>Collection</option>
					  <option>Delivery</option>
					</select></form></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td><strong>Select return slot:</strong>
				</td> 
				<td><form action="checkout.jsp"><select name="returnSlot" class="form-control">
					  <option>--Any--</option>
					  <option>AM</option>
					  <option>PM</option>
					</select></form></td>
				<td></td>
			</tr>
			<tr  class="bottom-line">
	        	<td></td>
	        	<td></td>
	        	<td></td>
	        	<td></td>
	        	<td></td>
	        	<td><strong>Deposit:</strong></td>
	        	<td><strong>&pound<%=deposit%></strong></td>
	        	<td></td>
	        	
	        </tr>
          <tr>
	        	<td></td>
	        	<td></td>
	        	<td></td>
	        	<td></td>
	        	<td></td>
	        	<td><strong>Basket total:</strong></td>
	        	<td><strong>&pound<%=totalCost += deposit %></strong></td>
	        	<td><a href="checkout.jsp"><input type="submit" class="btn btn-primary" value="Checkout"></a></td>
	        </tr>

          </tbody>
            </table>
          </div>
		</main>

</body>
</html>