package viewHelper;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Product;
import util.ProductHandler;

/* Servlet implementation class ProductList
*/
@WebServlet("/ProductList")
public class ProductList extends HttpServlet {
private static final long serialVersionUID = 1L;

/**
 * Default constructor. 
 */
public ProductList() {
    // TODO Auto-generated constructor stub
}

/**
 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
 */
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // Generate list of products; hand over to a JSP page to display them.
    // We can get any parameters we need from the request (we don't need/use any at the moment).
    ArrayList<Product> products = new ArrayList<Product>();
    try {
        String material = "";
        if(request.getParameter("material") != null) {
            material = request.getParameter("material");
        }
        String type = "";
        if(request.getParameter("type") != null) {
            type = request.getParameter("type");
        }
        String supplierName = "";
        if(request.getParameter("supplierName") != null) {
            supplierName = request.getParameter("supplierName");
        }

        int minPrice = 0;
        if (request.getParameter("minPrice") != null && !request.getParameter("minPrice").equals("")) {
            minPrice = Integer.parseInt(request.getParameter("minPrice"));
        }
        int maxPrice = 0;
        if (request.getParameter("maxPrice") != null && !request.getParameter("maxPrice").equals("")) {
            maxPrice = Integer.parseInt(request.getParameter("maxPrice"));
        }
        int minHeight = 0;
        if (request.getParameter("minHeight") != null && !request.getParameter("minHeight").equals("")) {
            minHeight = Integer.parseInt(request.getParameter("minHeight"));
        }
        int maxHeight = 0;
        if (request.getParameter("maxHeight") != null && !request.getParameter("maxHeight").equals("")) {
            maxHeight = Integer.parseInt(request.getParameter("maxHeight"));
        }

        products = ProductHandler.searchProducts(material, type, supplierName, minHeight, maxHeight, minPrice, maxPrice);
    } catch (SQLException e) {
         //TODO Auto-generated catch block
        e.printStackTrace();
    }
    // Rather than embed lots of HTML into servlets; place the data you wan tto handle into the request
    request.setAttribute("products", products);
    // ... then forward the request to a JSP 'hidden' inside WEB_INF (so, can't be accessed directly by the user)
    RequestDispatcher rd = request.getRequestDispatcher("products.jsp");
    rd.forward(request, response);
}

/**
 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
 */
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // If called via POST... do what we'd do if called via GET.
    doGet(request, response);
}
}