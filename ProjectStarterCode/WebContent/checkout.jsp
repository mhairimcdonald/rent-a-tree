<%--
	Document : checkout
	Author   : Mhairi McDonald
--%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	<%@ page import="java.sql.ResultSet" %>
	<%@ page import="util.BasketHandler" %>
	<%@ page import="java.util.Date" %>
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

	<main class="col-sm-12 col-md-12">
	<h1>Checkout</h1>
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-6">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">Account details</h3>
					</div>
					<div class="panel-body">
						<form action="/ProjectStarterCode/ConfirmOrder" method="post">
							<div class="row">
								<div class="col-md-12">
									<div class="form-group">
										<div class="row">
											<div class="col-md-12">
												<label>Name</label>
												<div class="input-group name">
													<input type="text" name="orderName" class="form-control"
														placeholder="Enter name" required autofocus />
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label>Address</label>
								<div class="row">
									<div class="col-xs-6 col-lg-6 pl-ziro">
										<input type="text" name="address" class="form-control" id="addLine1"
											placeholder="Address Line 1" required />
									</div>
									<div class="col-xs-6 col-lg-6 pl-ziro">
										<input type="text" name="postcode" class="form-control" id="postcode"
											placeholder="Postcode" required />
									</div>
								</div>
							</div>
							<div class="row">
							<div class="col-md-12">
								<div class="form-group">
									<label for="cardHolderName"> Card Holder Name</label>
									<div class="input-group">
										<input type="text" name="cardHolder" class="form-control card-name" id="cardHolder"
											placeholder="Card Holder Name" required />
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="form-group">
									<label for="cardNumber"> CARD NUMBER</label>
									<div class="input-group">
										<input type="text" class="form-control" name="cardNumber" id="cardNumber"
											placeholder="Valid Card Number" required /> <span
											class="input-group-addon"><span
											class="glyphicon glyphicon-lock"></span></span>
									</div>
								</div>
							</div>
						</div>
							<div class="row">
								<div class="col-xs-7 col-md-7">
									<div class="form-group">
										<label for="expiryMonth"> EXPIRY DATE</label>
										<div class="row">
											<div class="col-xs-6 col-lg-6 pl-ziro">
												<input type="text" name="expiryMonth" class="form-control" id="expityMonth"
													placeholder="MM" required />
											</div>
											<div class="col-xs-6 col-lg-6 pl-ziro">
												<input type="text" name="expiryYear" class="form-control" id="expityYear"
													placeholder="YY" required />
											</div>
										</div>
									</div>
								</div>
								<div class="col-xs-5 col-md-5 pull-right">
									<div class="form-group">
										<label for="cvCode"> CV CODE</label> <input type="password"
											class="form-control" id="cvCode" name="cvCode" placeholder="CV" required />
									</div>
								</div>
							</div>
							<a><button class="btn btn-success btn-lg btn-block" type="submit">Pay</button></a>
						</form>
					</div>
				</div>
			</div>
			<div class="col-md-6">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">Basket Summary</h3>
					</div>
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-striped">
								<thead>
									<tr>
										<th>Product Id</th>
										<th>Name</th>
										<th>Quantity</th>
										<th>Lease Duration</th>
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
							              double diffInDays = (double) (diffInMillies / (1000 * 60 * 60 * 24));
							              totalCost+= rs.getInt("PricePerDay") * diffInDays * rs.getInt("Quantity");
							        	  %>

									<tr class="prod p<%= rs.getInt("ProductId") %>">

										<td><%=rs.getInt("ProductId") %></td>
										<td><%=rs.getString("TreeType") %></td>
										<td><%=rs.getInt("Quantity") %></td>
										<td><%=diffInDays %></td>
									</tr>
									
									<%}%>	
								
									<tr class="bottom-line">
										<td></td>
										<td></td>
										<td><strong>Total price:</strong></td>
										<td><strong>&pound<%=totalCost += (totalCost / 10) %></strong></td>
									</tr>	
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>