/**
 * 
 */
package model;

/**
 * @author kelly.taylor
 *
 */
public class Address {
	String addressLine;
	String postcode;
	
	public Address(String addressLine, String postcode) {
		this.addressLine = addressLine;
		this.postcode = postcode;
	}
	
	public String getAddressLine() {
		return addressLine;
	}

	public void setAddressLine(String addressLine) {
		this.addressLine = addressLine;
	}

	public String getPostcode() {
		return postcode;
	}

	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}
}

