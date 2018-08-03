package model;

public class Product {
private int id; // id = -1 means no id set (a new, unsaved, product)
private String description;
private String supplier;
private double price;
private int stock;
private int height;
private String material;
private String type;

public Product(String description, String supplier, double price, int stock, int height, String material, String type){
    this(-1, description, supplier, price, stock, height, material, type);
}

public Product(int id, String description, String supplier, double price, int stock, int height, String material, String type){
    this.id = id;
    this.description = description;
    this.supplier = supplier;
    this.price = price;
    this.stock = stock;
    this.height = height;
    this.material = material;
    this.type = type;
}

public int getId() {
    return id;
}

public String getDescription() {
    return description;
}

public String getSupplier() {
    return supplier;
}

public double getPrice() {
	
    return price;
}

public int getStock() {
    return stock;
}

public int getHeight() {
    return height;
}

public String getMaterial() {
    return material;
}

public String getType() {
    return type;
}
}