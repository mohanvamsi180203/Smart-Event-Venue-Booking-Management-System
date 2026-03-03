package com.dto;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Booking Data Transfer Object
 * Represents a ticket booking in the system
 */
public class Booking {
    
    private int id;
    private int userId;
    private String userName; // For display purposes
    private String userEmail; // For display purposes
    private int eventId;
    private String eventTitle; // For display purposes
    private String bookingReference;
    private int numberOfTickets;
    private BigDecimal totalAmount;
    private String bookingStatus; // pending, confirmed, cancelled, refunded
    private String paymentMethod;
    private String paymentStatus; // pending, paid, failed, refunded
    private String paymentId;
    private Timestamp bookingDate;
    private Date eventDate;
    
    // Default constructor
    public Booking() {
    }
    
    // Constructor with essential fields
    public Booking(int userId, int eventId, String bookingReference, 
                   int numberOfTickets, BigDecimal totalAmount) {
        this.userId = userId;
        this.eventId = eventId;
        this.bookingReference = bookingReference;
        this.numberOfTickets = numberOfTickets;
        this.totalAmount = totalAmount;
        this.bookingStatus = "pending";
        this.paymentStatus = "pending";
    }
    
    // Getter and Setter methods
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
    
    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }
    
    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }
    
    public String getBookingReference() { return bookingReference; }
    public void setBookingReference(String bookingReference) { this.bookingReference = bookingReference; }
    
    public int getNumberOfTickets() { return numberOfTickets; }
    public void setNumberOfTickets(int numberOfTickets) { this.numberOfTickets = numberOfTickets; }
    
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    
    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
    public String getPaymentId() { return paymentId; }
    public void setPaymentId(String paymentId) { this.paymentId = paymentId; }
    
    public Timestamp getBookingDate() { return bookingDate; }
    public void setBookingDate(Timestamp bookingDate) { this.bookingDate = bookingDate; }
    
    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }
    
    @Override
    public String toString() {
        return "Booking{" +
                "id=" + id +
                ", bookingReference='" + bookingReference + '\'' +
                ", numberOfTickets=" + numberOfTickets +
                ", totalAmount=" + totalAmount +
                ", bookingStatus='" + bookingStatus + '\'' +
                '}';
    }
}
