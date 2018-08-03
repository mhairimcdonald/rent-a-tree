<%@ page language="java" contentType="text/html; charset=UTF8"
pageEncoding="UTF8"%>
<%@ page import="model.Product"%>
<%@ page import="util.ProductHandler"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<!doctype html>
<html>
<head>
<link
href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link rel="stylesheet"
href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
<meta charset="utf-8">
<title>RentATree | Products</title>
</head>
<body>
<%
int minPrice = ProductHandler.getMinPrice();
if (request.getParameter("minPrice") != null && !request.getParameter("minPrice").equals("")) {
minPrice = Integer.parseInt(request.getParameter("minPrice"));
}
int maxPrice = ProductHandler.getMaxPrice();
if (request.getParameter("maxPrice") != null && !request.getParameter("maxPrice").equals("")) {
maxPrice = Integer.parseInt(request.getParameter("maxPrice"));
}
int minHeight = ProductHandler.getMinHeight();
if (request.getParameter("minHeight") != null && !request.getParameter("minHeight").equals("")) {
minHeight = Integer.parseInt(request.getParameter("minHeight"));
}
int maxHeight = ProductHandler.getMaxHeight();
if (request.getParameter("maxHeight") != null && !request.getParameter("maxHeight").equals("")) {
maxHeight = Integer.parseInt(request.getParameter("maxHeight"));
}
%>

<%@include file="WEB-INF/jsp/navbar.jsp"%>

<div class="container-fluid">
    <main class="col-sm-9 offset-sm-3 col-md-12  pt-3">
    <h1>Products</h1>

    <form action="" method="POST">
        <div class="form-row">
            <div class="form-group col-md-4">
                <label for="material">Material:</label> <select
                    class="form-control" id="material" name="material">
                    <option></option>
                    <%
                        ArrayList<String> materials = ProductHandler.getMaterials();
                        for (String p : materials) {
                            String attribute = "";
                            if (request.getParameter("material") != null && request.getParameter("material").equals(p)) {
                                attribute = "selected";
                            }
                    %>
                    <option <%=attribute%>><%=p%></option>
                    <%
                        }
                    %>
                </select>
            </div>
            <div class="form-group col-md-4">
                <label for="type">Type:</label> <select class="form-control"
                    id="type" name="type">
                    <option></option>
                    <%
                        ArrayList<String> treeTypes = ProductHandler.getTreeTypes();
                        for (String p : treeTypes) {
                            String attribute = "";
                            if (request.getParameter("type") != null && request.getParameter("type").equals(p)) {
                                attribute = "selected";
                            }
                    %>
                    <option <%=attribute%>><%=p%></option>
                    <%
                        }
                    %>
                </select>
            </div>
            <div class="form-group col-md-4">
                <label for="supplierName">Supplier:</label> <select
                    class="form-control" id="supplierName" name="supplierName">
                    <option></option>
                    <%
                        ArrayList<String> suppliers = ProductHandler.getSuppliers();
                        for (String p : suppliers) {
                            String attribute = "";
                            if (request.getParameter("supplierName") != null && request.getParameter("supplierName").equals(p)) {
                                attribute = "selected";
                            }
                    %>
                    <option <%=attribute%>><%=p%></option>
                    <%
                        }
                    %>
                </select>
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label for="priceRange">Price range: </label> <input type="text"
                    id="priceRange" readonly style="border: 0; font-weight: bold;">
                <div id="price-slider"></div>
                <input type="hidden" id="minPrice" name="minPrice"
                    value="<%=minPrice%>"> <input type="hidden"
                    id="maxPrice" name="maxPrice" value="<%=maxPrice%>">
            </div>

            <div class="form-group col-md-6">
                <label for="heightRange">Height range: </label> <input type="text"
                    id="heightRange" readonly style="border: 0; font-weight: bold;">
                <div id="height-slider"></div>
                <input type="hidden" id="minHeight" name="minHeight"
                    value="<%=minHeight%>"> <input type="hidden"
                    id="maxHeight" name="maxHeight" value="<%=maxHeight%>">
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-12">
                <button type="submit" class="btn btn-primary mb-2">Search</button>
            </div>
        </div>
    </form>

    <section class="row text-center placeholders"></section>

    <div class="table-responsive">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Product Id</th>
                    <th>Name</th>
                    <th>Material</th>
                    <th>Height(cm)</th>
                    <th>Description</th>
                    <th>Supplier</th>
                    <th>Price per Day</th>
                    <th>Lease Start</th>
                    <th>Lease End</th>
                    <th>Quantity</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <%
                    // List of Products
                    String material = "";
                    if (request.getParameter("material") != null) {
                        material = request.getParameter("material");
                    }
                    String type = "";
                    if (request.getParameter("type") != null) {
                        type = request.getParameter("type");
                    }
                    String supplierName = "";
                    if (request.getParameter("supplierName") != null) {
                        supplierName = request.getParameter("supplierName");
                    }
                    ArrayList<Product> products = ProductHandler.searchProducts(material, type, supplierName, minHeight,
                            maxHeight, minPrice, maxPrice);
                    for (Product p : products) {
                %>
                <tr class="prod p<%=p.getId()%>">

                    <td><%=p.getId()%></td>
                    <td><%=p.getType()%></td>
                    <td><%=p.getMaterial()%></td>
                    <td><%=p.getHeight()%></td>
                    <td class="col-md-4"><%=p.getDescription()%></td>
                    <td><%=p.getSupplier() %></td>
                    <td>&pound<%=p.getPrice()%></td>
                    <form class="form-horizontal" action="/ProjectStarterCode/AddToBasket" method="get">
	                   
	                        <td><input type="date" name="LeaseStart" min="2017-12-01" max="2018-01-09" value="yyyy/mm/dd" size="20" class="col-xs-12"></input></td>
	                    
	                    	<td><input type="date" name="LeaseEnd" min="2017-12-05" max="2018-01-14" value="yyyy/mm/dd" size="20" class="col-xs-12"></input></td>
	                    
	                        <td><input type="text" name="qty" value="0" size="15" class="col-xs-5"></input></td>
	                            <input type="hidden" name="pid" value="<%=p.getId()%>">
<%if(session.getAttribute("username")!=null){ %>
                            <td><button type="submit">Purchase</button></td>
<% } else { %>
							<td><button type=button data-toggle="modal" data-target="#myModal">Log In to Purchase</button></td>
<% }  %>
                        
                    </form>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
    </main>
</div>

<script src="https://code.jquery.com/jquery-1.12.4.min.js"
    type="text/javascript">

</script>
<script
    src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js">

</script>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
    $(document).ready(
            function() {
                $("#price-slider").slider(
                        {
                            range : true,
                            min : <%=ProductHandler.getMinPrice()%>,
                            max : <%=ProductHandler.getMaxPrice()%>,
                            values : [<%=minPrice%>,<%=maxPrice%>],
                            slide : function(event, ui) {
                                $("#priceRange").val(
                                        "£" + ui.values[0] + " - £"
                                                + ui.values[1]);
                                $("#minPrice").val(ui.values[0]);
                                $("#maxPrice").val(ui.values[1]);
                            }
                        });
                $("#priceRange").val(
                        "£" + $("#price-slider").slider("values", 0)
                                + " - £"
                                + $("#price-slider").slider("values", 1));

                $("#height-slider").slider(
                        {
                            range : true,
                            min : <%=ProductHandler.getMinHeight()%>,
                            max : <%=ProductHandler.getMaxHeight()%>,
                            values : [<%=minHeight%>,<%=maxHeight%>],
                            slide : function(event, ui) {
                                $("#heightRange").val(
                                        ui.values[0] + "cm - "
                                                + ui.values[1] + "cm");
                                $("#minHeight").val(ui.values[0]);
                                $("#maxHeight").val(ui.values[1]);
                            }
                        });
                $("#heightRange").val(
                        $("#height-slider").slider("values", 0) + "cm - "
                                + $("#height-slider").slider("values", 1)
                                + "cm");
            });
</script>
</body>
</html>