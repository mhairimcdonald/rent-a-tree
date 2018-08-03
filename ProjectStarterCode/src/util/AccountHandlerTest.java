package util;

import static org.junit.Assert.*;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import org.junit.Test;

import model.Address;

public class AccountHandlerTest {
@Test
public void hashPasswordAndLoginTest() { // Basic test to show encoding and decoding
String testEmail = "kellyannetaylor@live.co.uk";
String testPassword = "IAmTwentyCharacters!";
int createdUserId = -1;
int loggedInUserId = -1;

    // Create account
    AccountHandler.createAccount(testEmail, testPassword, new Date(1991, 3, 3)); // Passwords no more than 20 characters

    // Test password is encoded
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT accountId, password FROM Account WHERE email = ?");) {
        ps.setString(1, testEmail);
        ResultSet resultSet = ps.executeQuery();
        if (resultSet.next()) {
            createdUserId = resultSet.getInt("AccountID");
            System.out.println(
                    "UserID: " + createdUserId + " Has Hashed Password:" + resultSet.getString("password"));
        }
    } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }

    // Test we can log in against the hashed password
    loggedInUserId = AccountHandler.login(testEmail, testPassword);
    System.out.println("Successfully logged in as userId: " + loggedInUserId);

    // Assert Id's are as expected
    assertFalse(createdUserId == -1);
    assertFalse(loggedInUserId == -1);
    assertEquals(createdUserId, loggedInUserId);

    // Cleanup database
    removeTestAccount(createdUserId);

    // Check cleanup was successful
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT accountId FROM Account WHERE email = ?");) {
        ps.setString(1, testEmail);
        ResultSet resultSet = ps.executeQuery();
        assertFalse(resultSet.next());
    } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
}

@Test
public void noTwoIdenticalPasswordsMatchTest() { // Test to show security of hashed passwords using salt
    String testEmailOne = "kellyannetaylor@live.co.uk";
    String testEmailTwo = "kelly.taylor@pinewood.co.uk";
    int accountIdOne = 0;
    int accountIdTwo = 0;
    String testPassword = "IAmTwentyCharacters!";
    String passwordOne = "";
    String passwordTwo = "";

    // Create accounts
    AccountHandler.createAccount(testEmailOne, testPassword, new Date(1991, 3, 3));
    AccountHandler.createAccount(testEmailTwo, testPassword, new Date(1991, 3, 3));

    // Test password is encoded
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT accountId, password FROM Account WHERE email = ?");) {
        ps.setString(1, testEmailOne);
        ResultSet resultSet = ps.executeQuery();
        if (resultSet.next()) {
            passwordOne = resultSet.getString("password");
            accountIdOne = resultSet.getInt("accountId");
        }
    } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT accountId, password FROM Account WHERE email = ?");) {
        ps.setString(1, testEmailTwo);
        ResultSet resultSet = ps.executeQuery();
        if (resultSet.next()) {
            passwordTwo = resultSet.getString("password");
            accountIdTwo = resultSet.getInt("accountId");
        }
    } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }

    //Ensure they don't match
    assertFalse(passwordOne.equals(passwordTwo));
    System.out.println("User One: " + passwordOne);
    System.out.println("User Two: " + passwordTwo);

    // Cleanup database
    removeTestAccount(accountIdOne);
    removeTestAccount(accountIdTwo);

    // Check cleanup was successful
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT accountId FROM Account WHERE email = ? OR email = ?");) {
        ps.setString(1, testEmailOne);
        ps.setString(2, testEmailTwo);
        ResultSet resultSet = ps.executeQuery();
        assertFalse(resultSet.next());
    } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
}

private void removeTestAccount(int accountId) {
    try (CallableStatement cs = DbConnector.getConnection().prepareCall("{call removeAccount(?)}");) {
        cs.setInt(1, accountId);
        cs.execute();
    } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
}


@Test
public void updateAccountTest() {
AccountHandler.updateAccountPasswords("password");

    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT accountId, password FROM Account");) {
        ResultSet resultSet = ps.executeQuery();
        if (resultSet.next()) {
            int createdUserId = resultSet.getInt("AccountID");
            System.out.println(
                    "UserID: " + createdUserId + " Has Hashed Password:" + resultSet.getString("password"));
        }
    } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
}
}