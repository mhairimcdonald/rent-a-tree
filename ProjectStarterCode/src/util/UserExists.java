package util;

public class UserExists extends Exception {
private String email;

public UserExists(String email) {
    this.email = email;
}

public String toString() {
    return "An account already exists with the email " + email;
}
}