package com.dto;

public class Seat {
    private int seatId;
    private int eventId;
    private String seatNumber;
    private String rowLabel;
    private int seatColumn;
    private String status; // AVAILABLE, LOCKED, BOOKED
    private Integer lockedBy;
    private java.sql.Timestamp lockTime;
    private Integer bookingId;
    private Integer sectionId; // Link to sections table
    private String sectionName; // For display purposes
    
    public Seat() {}
    
    public Seat(int seatId, int eventId, String seatNumber, String status) {
        this.seatId = seatId;
        this.eventId = eventId;
        this.seatNumber = seatNumber;
        this.status = status;
    }
    
    // Getters and Setters
    public int getSeatId() {
        return seatId;
    }
    
    public void setSeatId(int seatId) {
        this.seatId = seatId;
    }
    
    public int getEventId() {
        return eventId;
    }
    
    public void setEventId(int eventId) {
        this.eventId = eventId;
    }
    
    public String getSeatNumber() {
        return seatNumber;
    }
    
    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }
    
    public String getRowLabel() {
        return rowLabel;
    }
    
    public void setRowLabel(String rowLabel) {
        this.rowLabel = rowLabel;
    }
    
    public int getSeatColumn() {
        return seatColumn;
    }
    
    public void setSeatColumn(int seatColumn) {
        this.seatColumn = seatColumn;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Integer getLockedBy() {
        return lockedBy;
    }
    
    public void setLockedBy(Integer lockedBy) {
        this.lockedBy = lockedBy;
    }
    
    public java.sql.Timestamp getLockTime() {
        return lockTime;
    }
    
    public void setLockTime(java.sql.Timestamp lockTime) {
        this.lockTime = lockTime;
    }
    
    public Integer getBookingId() {
        return bookingId;
    }
    
    public void setBookingId(Integer bookingId) {
        this.bookingId = bookingId;
    }
    
    public boolean isAvailable() {
        return "AVAILABLE".equals(status);
    }
    
    public boolean isLocked() {
        return "LOCKED".equals(status);
    }
    
    public boolean isBooked() {
        return "BOOKED".equals(status);
    }
    
    // Section-related getters and setters
    public Integer getSectionId() {
        return sectionId;
    }
    
    public void setSectionId(Integer sectionId) {
        this.sectionId = sectionId;
    }
    
    public String getSectionName() {
        return sectionName;
    }
    
    public void setSectionName(String sectionName) {
        this.sectionName = sectionName;
    }
}
