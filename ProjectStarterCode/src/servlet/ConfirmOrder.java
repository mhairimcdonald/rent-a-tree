package servlet;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Session;
import util.DbConnector;
import util.PurchaseHandler;

/**
 * Servlet implementation class ConfirmOrder
 */
@WebServlet("/ConfirmOrder")
public class ConfirmOrder extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ConfirmOrder() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if(request.getParameter("orderName")!=null && request.getParameter("address")!=null
				&& request.getParameter("postcode")!=null
				&& request.getParameter("cardHolder")!=null
				&& request.getParameter("cardNumber")!=null
				&& request.getParameter("expiryMonth")!=null
				&& request.getParameter("expiryYear")!=null
				&& request.getParameter("cvCode")!=null) {
					String address = request.getParameter("address");
					String postcode = request.getParameter("postcode");
					String cardNo = request.getParameter("cardNumber");
					int purId = Session.getBasket().getId(); 
					int cId = -1;
					CallableStatement cs;
					try {
						cs = DbConnector.getConnection().prepareCall("{call insertCardDetail(?,?,?,?,?,?,?)}");
						cs.setString(1, request.getParameter("cardHolder"));
						cs.setString(2, cardNo);
						cs.setInt(3, Integer.valueOf(request.getParameter("expiryMonth")));
						cs.setInt(4, Integer.valueOf(request.getParameter("expiryYear")));
						cs.setInt(5, Integer.valueOf(request.getParameter("cvCode")));
						cs.setInt(6, Session.getAccount().getAccountId());
						cs.registerOutParameter(7, Types.INTEGER);
						cs.execute();
						cId = cs.getInt(7);
					} catch (SQLException e) {
						e.printStackTrace();
					}
					
					if(PurchaseHandler.confirmPurchase(address, postcode, cId, purId)) {
						response.sendRedirect("confirmed.jsp");
						return;
					}
		}
		response.sendRedirect("error.jsp");
	}

}
