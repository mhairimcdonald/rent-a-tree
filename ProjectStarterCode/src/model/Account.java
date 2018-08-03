/* 
*/
package model;

import java.util.Date;

import util.AccountHandler;

/* @author kelly.taylor*/
public class Account {
private int accountId;
private String email;

public Account(int accountId, String email) {
    this.accountId = accountId;
    this.email = email;
}

public static boolean createAccount(String email, String password, Date dob) {
    int accountId = AccountHandler.createAccount(email, password, dob);
    return accountId != -1;
}

/**
 * @return the accountId
 */
public int getAccountId() {
    return accountId;
}

/**
 * @return the email
 */
public String getEmail() {
    return email;
}
}