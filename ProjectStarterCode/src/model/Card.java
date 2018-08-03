package model;


public class Card {
	String cardNumber;
	String name;
	int expiryMonth;
	int expiryYear;
	int cvCode;
	int id;
	
	public Card(String cardNumber, String name, int expiryMonth, int expiryYear, int cvCode, int id) {
		this.cardNumber = cardNumber;
		this.name = name;
		this.expiryMonth = expiryMonth;
		this.expiryYear = expiryYear;
		this.cvCode = cvCode;
		this.id = id;
	}
	
	public String getCardNumber() {
		return cardNumber;
	}

	public String getName() {
		return name;
	}

	public int getExpiryMonth() {
		return expiryMonth;
	}

	public int getExpiryYear() {
		return expiryYear;
	}

	public int getCvCode() {
		return cvCode;
	}

	public int getId() {
		return id;
	}

}
