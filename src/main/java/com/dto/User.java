package com.dto;

import java.sql.Timestamp;

/**
 * User Data Transfer Object
 * Represents a user in the system with registration and verification details
 */
public class User {
    
    // Private fields for user data
    private int id;
    private String name;
    private String password;
    private String email;
    private int otp;
    private boolean isVerified;
    private Timestamp createdAt;
    
    // Default constructor
    public User() {
    }
    
    // Constructor with essential fields for registration
    public User(String name, String password, String email, int otp) {
        this.name = name;
        this.password = password;
        this.email = email;
        this.otp = otp;
        this.isVerified = false;
    }
    
    // Full constructor
    public User(int id, String name, String password, String email, int otp, boolean isVerified, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.password = password;
        this.email = email;
        this.otp = otp;
        this.isVerified = isVerified;
        this.createdAt = createdAt;
    }
    
    // Getter and Setter methods
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public int getOtp() { return otp; }
    public void setOtp(int otp) { this.otp = otp; }
    
    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean verified) { isVerified = verified; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", isVerified=" + isVerified +
                ", createdAt=" + createdAt +
                '}';
    }
}
