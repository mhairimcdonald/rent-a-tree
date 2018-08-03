package test;

import static org.junit.Assert.*;

import java.sql.Connection;
import java.sql.SQLException;

import org.junit.Test;

import util.DbConnector;

public class DbConnectorTest {

	@Test
	public void getConnectionTest() {
		Connection c = null;
		try {
			c = DbConnector.getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
			fail("Unable to get Connection");
		}
		assertNotNull(c);
	}

}
