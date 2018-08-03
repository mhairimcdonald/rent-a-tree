<%@ page language="java" contentType="text/html; charset=UTF8"
pageEncoding="UTF8"%>
<%@ page import="model.Product"%>
<%@ page import="model.Session"%>
<%@ page import="model.Account"%>
<%@ page import="model.Admin"%>
<%@ page import="util.ProductHandler"%>
<%@ page import="util.AccountHandler"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<!doctype html>
<html>
<head>
<link
href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>RentATree | Admin</title>
</head>
<body>

<%@include file="WEB-INF/jsp/navbar.jsp"%>

<div class="container-fluid">
    <main class="col-sm-9 offset-sm-3 col-md-12  pt-3">
    <h1>Admin Tools</h1>

    <h2 class="col-md-12">Register Customer Hit</h2>
    <form action="" method="POST">
        <div class="form-row">
            <div class="form-group col-md-6">
                <%
                    String hitMessage = "";
                    if (request.getParameter("hitSubmit") != null) {
                        if (Session.getAccount() instanceof Admin) {
                            hitMessage = ((Admin) Session.getAccount()).incrementHit(request.getParameter("hitEmail"));
                        } else {
                            hitMessage = "ADMIN PRIVILEGES NEEDED";
                        }
                    }
                %>
                <label for="hitEmail">Customer Email:</label> <input type="text"
                    id="hitEmail" name="hitEmail" class="form-control" />
            </div>
            <div class="form-group form-inline col-md-12">
                <button type="submit" class="btn btn-primary mb-3" name="hitSubmit"
                    value="hitSubmit">Confirm</button>
                <Label><%=hitMessage%></Label>
            </div>
        </div>
    </form>

    <h2 class="col-md-12">Register Customer Miss</h2>
    <form action="" method="POST">
        <div class="form-row">
            <div class="form-group col-md-6">
                <%
                    String missMessage = "";
                    if (request.getParameter("missSubmit") != null) {
                        if (Session.getAccount() instanceof Admin) {
                            missMessage = ((Admin) Session.getAccount()).incrementMiss(request.getParameter("missEmail"));
                        }  else  {
                            missMessage = "ADMIN PRIVILEGES NEEDED";
                        }
                    }
                %>
                <label for="missEmail">Customer Email:</label> <input type="text"
                    id="missEmail" name="missEmail" class="form-control" />
            </div>
            <div class="form-group form-inline col-md-12">
                <button type="submit" class="btn btn-primary mb-3" name="missSubmit"
                 value="missSubmit">Confirm</button>
                <Label><%=missMessage%></Label>
            </div>
        </div>
    </form>
    </main>
</div>

<script src="https://code.jquery.com/jquery-1.12.4.min.js"
    type="text/javascript">

</script>
<script
    src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js">

</script>
</body>
</html>