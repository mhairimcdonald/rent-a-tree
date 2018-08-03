/* 
*/
package model;

import java.sql.SQLException;

import util.AccountHandler;

/* @author kelly.taylor
*/
public class Admin extends Account {

public Admin(int accountId, String email) {
    super(accountId, email);
}

public void updateStock(Product product, int qty) {

}

public void addProduct(Product product, int qty) {

}

public void removeProduct(Product product, int qty) {

}

public String incrementHit(String email) {
    return incrementCustomerTally(email, "hit");
}

public String incrementMiss(String email) {
    return incrementCustomerTally(email, "miss");
}

private String incrementCustomerTally(String email, String type) {
    int accountId = AccountHandler.getAccountId(email);
    if(accountId == -1) {
        return "Account not found";
    }
    try {
        if(type.equals("hit")) {
            AccountHandler.incrementHit(accountId);
        } else if(type.equals("miss")) {
            AccountHandler.incrementMiss(accountId);
        } else {
            return "Invalid update.";
        }
    } catch (SQLException e) {
        e.printStackTrace();
        return "Something went wrong. Please try again later.";
    }
    String message = "Incremented " + type + " for " + email + " successfully.";
    if(type.equals("hit")) {
        try {
            message += " Total: " + AccountHandler.getHits(accountId);
        } catch (SQLException e) {
            e.printStackTrace();
            return "Hit updated. Unable to confirm total.";
        }
    } else if(type.equals("miss")) {
        try {
            message += " Total: " + AccountHandler.getMisses(accountId);
        } catch (SQLException e) {
            e.printStackTrace();
            return "Miss updated. Unable to confirm total.";
        }
    }
    return message;
}
}