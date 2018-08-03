package model;

import java.util.Date;

public class BasketItem {
	private Product product;
	private int qty;
	private Date leaseStart;
	private Date leaseEnd;
	private String collectionType;
	private String returnType;
	private String collectionSlot;
	private String returnSlot;
	private int id;
	private int productId;
	
	public BasketItem(Product product, int qty, Date leaseStart, Date leaseEnd, String collectionType, String returnType, String collectionSlot, String returnSlot, int id) {
		this.product = product;
		this.qty = qty;
		this.leaseStart = leaseStart;
		this.leaseEnd = leaseEnd;
		this.collectionType = collectionType;
		this.returnType = returnType;
		this.collectionSlot = collectionSlot;
		this.returnSlot = returnSlot;
		this.id = id;
	}
	
	public BasketItem(int productId, int qty, Date leaseStart, Date leaseEnd) {
		this.productId = productId;
		this.qty = qty;
		this.leaseStart = leaseStart;
		this.leaseEnd = leaseEnd;
		
	}
	
	

	public double getTotalCost() { //Rename to getTotalCost OR return the value before deposit/delivery
		double totalCost = product.getPrice() * qty; //Needs to take into consideration Qty
		totalCost+=getCollectionCost();
		totalCost+=getReturnCost();
		totalCost+=getDeposit();
		return totalCost;
	}
	/*
	 * @returns deposit as 10% of price
	 */
	public double getDeposit() {
		return product.getPrice() / 10;
	}
	
	public double getCollectionCost() {
		double collCost = 0;
		if(collectionType.equals("delivery")) {
			if(collectionSlot.equals("am") || collectionSlot.equals("pm")) {
				collCost = 3.99;
			}
		}
		return collCost;
	}
	
	public double getReturnCost() {
		double retCost = 0;
		if(returnType.equals("collection")) {
			if(returnSlot.equals("am") || returnSlot.equals("pm")) {
				retCost = 3.99;
			}
		}
		return retCost;
	}
	
	public int getLeaseDuration() {
		return 0;
	}

	public Product getProduct() {
		return product;
	}
	
	public int getProductId() {
		return productId;
	}

	public int getQty() {
		return qty;
	}

	public Date getLeaseStart() {
		return leaseStart;
	}

	public Date getLeaseEnd() {
		return leaseEnd;
	}

	public String getCollectionType() {
		return collectionType;
	}

	public String getReturnType() {
		return returnType;
	}

	public String getCollectionSlot() {
		return collectionSlot;
	}

	public String getReturnSlot() {
		return returnSlot;
	}

	public int getId() {
		return id;
	}

}
