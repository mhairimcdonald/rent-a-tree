/**
 * 
 */
package model;

import java.sql.SQLException;
import java.util.Date;

import util.AccountHandler;
import util.BasketHandler;

/**
 * @author kelly.taylor, mhairi.mcdonald
 *
 */
public class Session {
	static Account account;
	static Basket basket;
	
	public Session() {
		account = null;
		basket = new Basket();
	}
	
	public boolean login(String username, String password) {
		int userId = AccountHandler.login(username, password);
		boolean success = userId != -1;
		if(success) {
			account = AccountHandler.getAccount(userId);
			try {
				basket = BasketHandler.getBasket();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return success;
	}
	
	public void confirmPurchase() {
		//TODO: Check user signed in
		if(isSignedIn()) {
			//TODO: Submit basket to the database
			//call method to update purchase
		}
		
		//TODO: Throw exceptions if no payment type or address or items
	}
	
	public void removeItem(int index) {
		if(isSignedIn()) {
			//TODO: update database
		}
		basket.removeItem(index);
	}
	
	public void addItem(Product product, int qty, Date leaseStart, Date leaseEnd, String collectionType,
			String returnType, String collectionSlot, String returnSlot) {
		//TODO: If logged in update database
	}
	
	public static void logout() {
		account = null;
		basket = new Basket();
	}
	
	public static boolean isSignedIn() {
		return account != null;
	}
	
	public static Account getAccount() {
		return account;
	}
	
	public static Basket getBasket() {
		return basket;
	}
}

