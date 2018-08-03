package util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import model.Account;
import model.Address;
import model.Admin;
import model.Product;

public class ProductHandler {

public static ArrayList<Product> getAllProducts() throws SQLException {
    ArrayList<Product> products = new ArrayList<Product>();
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT * FROM Product");) {
        ResultSet resultSet = ps.executeQuery();
        products = resultSetToProducts(resultSet);
    } catch (SQLException e) {
        System.err.println(e);
        e.printStackTrace();
    }
    return products;
}

public static ArrayList<String> getMaterials() throws SQLException {
    ArrayList<String> materials = new ArrayList<String>();
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT DISTINCT Material FROM Product ORDER BY Material");) {
        ResultSet resultSet = ps.executeQuery();
        materials = resultSetToStrings(resultSet, "Material");
    } catch (SQLException e) {
        System.err.println(e);
        e.printStackTrace();
    }
    return materials;
}

public static ArrayList<String> getTreeTypes() throws SQLException {
    ArrayList<String> materials = new ArrayList<String>();
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT DISTINCT TreeType FROM Product ORDER BY TreeType");) {
        ResultSet resultSet = ps.executeQuery();
        materials = resultSetToStrings(resultSet, "TreeType");
    } catch (SQLException e) {
        System.err.println(e);
        e.printStackTrace();
    }
    return materials;
}

public static ArrayList<String> getSuppliers() throws SQLException {
    ArrayList<String> materials = new ArrayList<String>();
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT DISTINCT SupplierName FROM Product ORDER BY SupplierName");) {
        ResultSet resultSet = ps.executeQuery();
        materials = resultSetToStrings(resultSet, "SupplierName");
    } catch (SQLException e) {
        System.err.println(e);
        e.printStackTrace();
    }
    return materials;
}

public static int getMinPrice() throws SQLException {
    int minPrice = 0;
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT MIN(PricePerDay) AS Price FROM Product");) {
        ResultSet resultSet = ps.executeQuery();
        if (resultSet.next()) {
            minPrice = resultSet.getInt("Price");
        }
    } catch (SQLException e) {
        System.err.println(e);
        e.printStackTrace();
    }
    return minPrice;
}

public static int getMaxPrice() throws SQLException {
    int maxPrice = 0;
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT MAX(PricePerDay) AS Price FROM Product");) {
        ResultSet resultSet = ps.executeQuery();
        if (resultSet.next()) {
            maxPrice = resultSet.getInt("Price");
        }
    } catch (SQLException e) {
        System.err.println(e);
        e.printStackTrace();
    }
    return maxPrice;
}

public static int getMinHeight() throws SQLException {
    int minHeight = 0;
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT MIN(Height) AS Height FROM Product");) {
        ResultSet resultSet = ps.executeQuery();
        if (resultSet.next()) {
            minHeight = resultSet.getInt("Height");
        }
    } catch (SQLException e) {
        System.err.println(e);
        e.printStackTrace();
    }
    return minHeight;
}

public static int getMaxHeight() throws SQLException {
    int maxHeight = 0;
    try (Connection con = DbConnector.getConnection();
            PreparedStatement ps = con
                    .prepareStatement("SELECT MAX(Height) AS Height FROM Product");) {
        ResultSet resultSet = ps.executeQuery();
        if (resultSet.next()) {
            maxHeight = resultSet.getInt("Height");
        }
    } catch (SQLException e) {
        System.err.println(e);
        e.printStackTrace();
    }
    return maxHeight;
}

public static ArrayList<String> resultSetToStrings(ResultSet rs, String columnName) throws SQLException {
    ArrayList<String> strings = new ArrayList<String>();

    while (rs.next()) {
        strings.add(rs.getString(columnName));
    }
    return strings;
}

public static ArrayList<Product> resultSetToProducts(ResultSet rs) throws SQLException {
    ArrayList<Product> products = new ArrayList<Product>();

    while (rs.next()) {
        Product p = new Product(rs.getInt("ProductID"), rs.getString("Description"), rs.getString("SupplierName"),
                rs.getInt("PricePerDay"), rs.getInt("StockLevel"), rs.getInt("Height"), rs.getString("Material"),
                rs.getString("TreeType"));
        products.add(p);
    }
    return products;
}

public static ArrayList<Product> searchProducts(String material, String treeType, String supplier, int minHeight,
        int maxHeight, int minPrice, int maxPrice) throws SQLException {
    ArrayList<Product> products = new ArrayList<Product>();
    boolean includeHeight = minHeight != 0 || maxHeight != 0;
    boolean includePrice = minPrice != 0 || maxPrice != 0;
    material = '%' + material + '%';
    treeType = '%' + treeType + '%';
    supplier = '%' + supplier + '%';

    String statement = "SELECT * FROM Product WHERE Material LIKE ? AND TreeType LIKE ? AND SupplierName LIKE ?";
    if (includeHeight) {
        statement += " AND (Height BETWEEN ? AND ?)";
    }
    if (includePrice) {
        statement += " AND (PricePerDay BETWEEN ? AND ?)";
    }

    try (Connection con = DbConnector.getConnection(); PreparedStatement ps = con.prepareStatement(statement);) {
        ps.setString(1, material);
        ps.setString(2, treeType);
        ps.setString(3, supplier);
        if (includeHeight && includePrice) {
            ps.setInt(4, minHeight);
            ps.setInt(5, maxHeight);
            ps.setInt(6, minPrice);
            ps.setInt(7, maxPrice);
        } else if (includeHeight) {
            ps.setInt(4, minHeight);
            ps.setInt(5, maxHeight);
        } else if (includePrice) {
            ps.setInt(4, minPrice);
            ps.setInt(5, maxPrice);
        }
        products = resultSetToProducts(ps.executeQuery());
    } catch (SQLException e) {
        System.err.println(e);
        e.printStackTrace();
    }

    return products;
}
}