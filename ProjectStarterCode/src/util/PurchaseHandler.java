package util;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.Card;
import model.Session;

public class PurchaseHandler {

	public PurchaseHandler() {
		
	}
	
	public ResultSet getCardDetails() throws SQLException{
		String query = "SELECT c.CardDetailId, c.CardNumber, c.CardMonth, c.CardDate, c.CardName, c.AccountId, c.CvCode FROM CardDetail c"
				+ "			JOIN Purchase ON c.AccountId = pur.AccountId"
				+ "			WHERE pur.AccountId = " + Session.getAccount().getAccountId();
		ResultSet rs = DbConnector.runSqlQuery(query);
		return rs;
	}
	
	public Card getCard() throws SQLException{
		ResultSet rs = getCardDetails();
		Card c = new Card(rs.getString("CardNumber"), rs.getString("CardName"), rs.getInt("CardMonth"), rs.getInt("CardDate"), rs.getInt("CvCode"), rs.getInt("CardDetailId"));
		return c;
	}
	

	public static boolean confirmPurchase(String address, String postcode, int cId, int purId) {
		CallableStatement cs;
		try {
			
			cs = DbConnector.getConnection().prepareCall("{call UpdatePurchase(?,?,?,?,?)}");
			cs.setString(1, address);
			cs.setString(2, postcode);
			cs.setInt(3, 0);
			cs.setInt(4, cId);
			cs.setInt(5, purId);
			cs.execute();
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}
}
