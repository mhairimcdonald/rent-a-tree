/**
 * 
 */
package util;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import model.Basket;
import model.BasketItem;
import model.Product;
import model.Session;

/**
 * @author mhairi.mcdonald
 *
 */
public class BasketHandler {
	
	public static boolean addToBasket(int pid, int qty, String lStart, String lEnd){		
		try {
			Date lStartAsDate = null, lEndAsDate = null;
			try {
				System.out.println(lStart + " " + lEnd);
				lStartAsDate = new SimpleDateFormat("yyyy-MM-dd").parse(lStart);
				lEndAsDate = new SimpleDateFormat("yyyy-MM-dd").parse(lEnd);
			} catch (ParseException e) {

				e.printStackTrace();
			}
			
			CallableStatement cs = DbConnector.getConnection().prepareCall("{call InsertProductToBasket(?,?,?,?,?)}");
			cs.setInt(1, Session.getBasket().getId());
			cs.setInt(2, pid);
			cs.setInt(3,  qty);
			cs.setDate(4,  new java.sql.Date(lStartAsDate.getTime()) );
			cs.setDate(5,  new java.sql.Date(lEndAsDate.getTime()));
			cs.execute();
			return true;
		} catch(SQLException sqle){
			System.out.println(sqle);
		}
		return false;
		
	}
	
	
	public static ResultSet getItemsFromBasket() throws SQLException{
		// Uh-oh - STILL no support for an 'order id' so I can't tell one person's order from another
		// Better way to do this (than using a raw SQL query)?
		String query = "SELECT po.PurchaseId, p.ProductId, p.TreeType, p.Description, p.Height, p.Material, p.PricePerDay, p.SupplierName, p.StockLevel, po.Quantity, po.LeaseStart, po.LeaseEnd FROM ProductOrder po"
				+ "			JOIN Product p ON po.productId = p.Productid"
				+ "			JOIN Purchase pur ON pur.PurchaseId = po.PurchaseId"							
				+ "			 WHERE pur.AccountId = " + Session.getAccount().getAccountId();
		ResultSet rs = DbConnector.runSqlQuery(query);
		return rs;
		
	}
	
	public static Basket getBasket() throws SQLException{
		Basket b = new Basket();
		ResultSet rs = getItemsFromBasket();
		while(rs.next()) {
			b.setId(rs.getInt("PurchaseId"));
			Product p = new Product(rs.getInt("ProductId"), rs.getString("Description"), rs.getString("SupplierName"), rs.getInt("PricePerDay"), rs.getInt("StockLevel"), rs.getInt("Height"), rs.getString("Material"), rs.getString("TreeType"));
			b.addItem(p, rs.getInt("Quantity"), rs.getDate("LeaseStart"), rs.getDate("LeaseEnd"), "", "", "", "");
		}
		return b;
	}
	
	

}
