<%--
	Document : basket
	Author   : Mhairi McDonald, Ella Kaderkutty
--%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="model.Session" %>
<!DOCTYPE html>
<html>
<head>
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" >
<link href="css/style.css" rel="stylesheet" >
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>RentATree</title>
</head>
<body>

       <%@include file="WEB-INF/jsp/navbar.jsp" %>
    

    <!-- Main jumbotron -->
    <div class="jumbotron">
      <div class="container home-page-tag">
        <h1 class="display3">RentATree</h1>
        <p>Ever thought about renting your Christmas tree?</p>
        <p>Whether it be for a business or a home, we can take the hassle out of the task by providing a service so everyone can sit by the perfect tree this Christmas.</p>
      </div>
    </div>
    <div class="container">
           <div class ="row"> 
                 <div class ="col-md-12">
                        <div class="howto">
                              <h2><b><em>How to RentATree</em></b></h2>
                              <p>RentATree is easy:</p>
                                 <p>1. Choose your tree,</p>
                              <p>2. Choose to pick-up or have it delivered,</p>
                              <p>3. Pay,</p>
                              <p>4. Enjoy a stress free Christmas</p>
                        </div>
                 </div>
           </div>
    </div>
    
    <div class="container">
      <h2><b><em>Protecting The Environment.</em></b></h2>
        <p>By renting a living Christmas tree you are helping us on our quest to protect the environment. </p>
        <p>Living Christmas trees absorb carbon dioxide and produce oxygen, improving air quality for humans and animals. They also provide habitats for wild-life.</p>
      <p>All of our trees are cared for all year round by us. Our special potted trees are extremely fresh as they aren't kept in nets and their shapes are as perfect as can be. Our artificial trees are recyclable, unlike normal retail ones, and are disposed of correctly to ensure it's as safe for the planet as possible.</p>
      <p>If a natural tree is not disposed of correctly, it can also be harmful to the environment. As it decomposes it produces methane gas, which is 25 times more potent as a greenhouse gas than carbon dioxide. Burning, planting or chipping significantly reduces the carbon footprint by up to 80%. Therefore, by renting a tree from us, we can ensure trees are cared for all year round and, when needed, are disposed of correctly.</p>
      </div>

<script src="https://code.jquery.com/jquery-1.12.4.min.js" type ="text/javascript"> </script >
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" > </script >
</body>
</html>
