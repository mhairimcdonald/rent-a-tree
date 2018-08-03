/**
 * 
 */
package model;

import java.util.ArrayList;
import java.util.Date;

/**
 * @author kelly.taylor, mhairi.mcdonald
 *
 */
public class Basket {
	ArrayList<BasketItem> contents;
	Address deliveryAddress;
	int id;
	//Card payment;
	
	public Basket() {
		contents = new ArrayList<BasketItem>();
	}
	
	public void addItem(Product product, int qty, Date leaseStart, Date leaseEnd, String collectionType,
			String returnType, String collectionSlot, String returnSlot) {
		this.addItem(product, qty, leaseStart, leaseEnd, collectionType, returnType, collectionSlot, returnSlot, -1);
	}
	
	public void addItem(Product product, int qty, Date leaseStart, Date leaseEnd, String collectionType,
			String returnType, String collectionSlot, String returnSlot, int id) {
		contents.add(new BasketItem(product, id, leaseEnd, leaseEnd, returnSlot, returnSlot, returnSlot, returnSlot, id)); //Update this to be correct
	}
	

	
	public void removeItem(int index) {
		contents.remove(index);
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	public int getId() {
		return id;
	}
	

	public double getTotalCost() {
		double totalCost = 0;
		for(BasketItem item : contents) {
			totalCost += item.getTotalCost();
		}
		return totalCost;
	}

	
}

