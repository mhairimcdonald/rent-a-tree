/* 
*/
package util;

import java.security.SecureRandom;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Base64;

import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import model.Account;
import model.Address;
import model.Admin;

/* @author kelly.taylor*/
public class AccountHandler {
// The larger these numbers are the more secure the hash is
// Equals higher computational cost on both sides however
//DO NOT CHANGE THESE AS IT WILL RESULT IN DIFFERENT PASSWORDS. A database update would be required.
private static final int iterations = 20 * 1000;
private static final int saltLen = 32;
private static final int desiredKeyLen = 256;

public static void updateAccountPasswords(String password) {
    try {
        password = getSaltedHash(password);
    } catch (Exception e2) {
        // TODO Auto-generated catch block
        e2.printStackTrace();
    }

    try(Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("UPDATE Account SET password = ?");){
        ps.setString(1, password);
        ps.executeQuery();
    } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
}

public static Account getAccount(int accountId) {
    Account account = null;
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT email, accountType FROM Account WHERE accountId = ?");) {
        ps.setInt(1, accountId);
        ResultSet resultSet = ps.executeQuery();
        if (resultSet.next()) {
            String email = resultSet.getString("email");
            if(resultSet.getString("accountType").equals("User")) {
                account = new Account(accountId, email);
            } else if (resultSet.getString("accountType").equals("Admin")) {
                account = new Admin(accountId, email);
            }
        }
    } catch (SQLException e) {
        System.err.println(e);
        e.printStackTrace();
    }

    return account;
}

public static int getAccountId(String email) {
    int accountId = -1;
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT accountId FROM Account WHERE email = ?");) {
        ps.setString(1, email);
        ResultSet resultSet = ps.executeQuery();
        if (resultSet.next()) {
            accountId = resultSet.getInt("accountId");
        }
    } catch (SQLException e) {
        System.err.println(e);
        e.printStackTrace();
    }

    return accountId;
}

public static int createAccount(String email, String password, java.util.Date dob) {
    email = email.toLowerCase();
    int userId = -1;
    try {
        password = getSaltedHash(password);
    } catch (Exception e2) {
        // TODO Auto-generated catch block
        e2.printStackTrace();
    }

  //Check account doesn't exist
    try(Connection con = DbConnector.getConnection();
    PreparedStatement ps = con
    .prepareStatement("SELECT accountId, password FROM Account WHERE email = ?");){
    ps.setString(1, email);
    ResultSet resultSet = ps.executeQuery();
    if (resultSet.next()) {
    throw new UserExists(email);
    }
    } catch (SQLException se) {
    se.printStackTrace();
    } catch (Exception e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
    }

    //If not insert account
    try (CallableStatement cs = DbConnector.getConnection().prepareCall("{call insertAccount(?,?,?,?,?,?,?,?)}");) {
        cs.setString(1, email); //Email
        cs.setString(2, password); //Password
        cs.setDate(3, new Date(dob.getYear(), dob.getMonth(), dob.getDate())); //DateOfBirth
        cs.setString(4, "Admin"); //AccountType
        cs.setInt(5, 0); //Hit
        cs.setInt(6, 0); //Miss
        cs.setString(7, "N"); //Suspended
        cs.registerOutParameter(8, Types.INTEGER);
        cs.execute();
        userId = cs.getInt(8); 
    } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
    return userId;
}

public static int login(String email, String password) throws IllegalStateException {
    int accountId = -1;
    email = email.toLowerCase();
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT accountId, password FROM Account WHERE email = ?");) {
        ps.setString(1, email);
        ResultSet resultSet = ps.executeQuery();
        if (resultSet.next()) {
            // we found users with matching username!!!
            String dbPassword = resultSet.getString("password"); // Get the stored password
            String[] saltAndPass = dbPassword.split("\\$"); // Split the stored password into the 'salt' and 'hash'

            if (saltAndPass.length != 2) { // This is not in the format we expect
                throw new IllegalStateException( // Throw exception as this shouldn't happen
                        "The stored password have the form 'salt$hash'");
            }

            String hashOfInput = hash(password, Base64.getDecoder().decode(saltAndPass[0]));
            if (hashOfInput.equals(saltAndPass[1])) {
                accountId = resultSet.getInt("accountId");
            }
        }
    } catch (SQLException e) {
        System.err.println(e);
        e.printStackTrace();
    } catch (Exception e) {
        System.err.println(e);
        e.printStackTrace();
    }
    return accountId;
}

public static void incrementHit(int accountId) throws SQLException {
    try (CallableStatement cs = DbConnector.getConnection().prepareCall("{call IncrementHit(?)}");) {
        cs.setInt(1, accountId);
        cs.execute();
    } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
}

public static int getHits(int accountId) throws SQLException {
    int hits = 0;
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT hit FROM Account WHERE accountId = ?");) {
        ps.setInt(1, accountId);
        ResultSet rs = ps.executeQuery();
        if(rs.next()) {
            hits = rs.getInt("hit");
        }
    } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
    return hits;
}

public static void incrementMiss(int accountId) throws SQLException {
    try (CallableStatement cs = DbConnector.getConnection().prepareCall("{call IncrementMiss(?)}");) {
        cs.setInt(1, accountId);
        cs.execute();
    } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
}

public static int getMisses(int accountId) throws SQLException {
    int misses = 0;
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT miss FROM Account WHERE accountId = ?");) {
        ps.setInt(1, accountId);
        ResultSet rs = ps.executeQuery();
        if(rs.next()) {
            misses = rs.getInt("miss");
        }
    } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
    return misses;
}

private static String getSaltedHash(String password) throws Exception {
    byte[] salt = SecureRandom.getInstance("SHA1PRNG").generateSeed(saltLen);
    // store the salt with the password
    return Base64.getEncoder().encodeToString(salt) + "$" + hash(password, salt);
}

private static String hash(String password, byte[] salt) throws Exception {
    SecretKeyFactory f = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
    SecretKey key = f.generateSecret(new PBEKeySpec(password.toCharArray(), salt, iterations, desiredKeyLen));
    return Base64.getEncoder().encodeToString(key.getEncoded());
}


}
