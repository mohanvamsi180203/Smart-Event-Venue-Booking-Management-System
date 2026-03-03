package com.dto;

import java.sql.Timestamp;

/**
 * Organizer Data Transfer Object
 * Represents an event organizer in the system
 */
public class Organizer {
    
    private int id;
    private String name;
    private String email;
    private String password;
    private String phone;
    private String companyName;
    private String address;
    private String status; // pending, approved, rejected
    private boolean isVerified;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Integer approvedBy;
    private Timestamp approvedAt;
    
    // Default constructor
    public Organizer() {
    }
    
    // Constructor with essential fields
    public Organizer(String name, String email, String password, String phone, String companyName) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.companyName = companyName;
        this.status = "pending";
        this.isVerified = false;
    }
    
    // Full constructor
    public Organizer(int id, String name, String email, String password, String phone, 
                     String companyName, String address, String status, boolean isVerified,
                     Timestamp createdAt, Timestamp updatedAt, Integer approvedBy, Timestamp approvedAt) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.companyName = companyName;
        this.address = address;
        this.status = status;
        this.isVerified = isVerified;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.approvedBy = approvedBy;
        this.approvedAt = approvedAt;
    }
    
    // Getter and Setter methods
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean verified) { isVerified = verified; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public Integer getApprovedBy() { return approvedBy; }
    public void setApprovedBy(Integer approvedBy) { this.approvedBy = approvedBy; }
    
    public Timestamp getApprovedAt() { return approvedAt; }
    public void setApprovedAt(Timestamp approvedAt) { this.approvedAt = approvedAt; }
    
    @Override
    public String toString() {
        return "Organizer{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", companyName='" + companyName + '\'' +
                ", status='" + status + '\'' +
                ", isVerified=" + isVerified +
                '}';
    }
}
