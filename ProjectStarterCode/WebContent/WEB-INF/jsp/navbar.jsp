
<nav class="navbar navbar-inverse navbar-fixed-top">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#navbar" aria-expanded="false"
				aria-controls="navbar">
				<span class="sr-only">Toggle navigation</span> <span
					class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="index.jsp">Rent-A-Tree</a>
		</div>
		<div id="navbar" class="navbar-collapse collapse">
<% if(session.getAttribute("username")!=null){ %>
			<form action="logout.jsp"><button type="button" class="btn btn-primary login navbar-btn navbar-right"  id="logout-btn">Log Out</button></form>	
<% } else { %>
			<button type="button" data-toggle="modal" data-target="#myModal"
				class="btn btn-primary login navbar-btn navbar-right"  id="login-btn">Login</button>
<% } %>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="index.jsp">Home</a></li>
				<li><a href="products.jsp">Products</a></li>
<% if(session.getAttribute("username")!=null){ %>
				<li><a href="basket.jsp">Basket</a></li>
<% } %>
<% if(session.getAttribute("username")!=null){ %>
				<li class="nav-user"><a href="#"><%=session.getAttribute("username") %></a></li>
<% } %>
			</ul>
		</div>
	</div>
</nav>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">Log in to your account</h4>
			</div>
			<div class="modal-body">
				<form method="post" action="login.jsp">
					<div class="form-group">
						<label>Username</label> <input class="form-control" name="username" placeholder="Enter username">
					</div>
					<div class="form-group">
						<label>Password</label> <input  class="form-control" type="password" name="password" placeholder="Enter password">
					</div>
					<button type="submit" class="btn btn-default">Submit</button>
				</form>
			</div>
		</div>
	</div>
</div>