package com.dto;

import java.math.BigDecimal;

public class Section {
    private int id;
    private int eventId;
    private String sectionName;
    private int rows;
    private int seatsPerRow;
    private BigDecimal price;
    private String rowStartLabel; // Starting row label (e.g., "A", "1")
    
    public Section() {}
    
    public Section(int id, int eventId, String sectionName, int rows, int seatsPerRow, BigDecimal price) {
        this.id = id;
        this.eventId = eventId;
        this.sectionName = sectionName;
        this.rows = rows;
        this.seatsPerRow = seatsPerRow;
        this.price = price;
    }
    
    // Calculate total seats in this section
    public int getTotalSeats() {
        return rows * seatsPerRow;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getEventId() {
        return eventId;
    }
    
    public void setEventId(int eventId) {
        this.eventId = eventId;
    }
    
    public String getSectionName() {
        return sectionName;
    }
    
    public void setSectionName(String sectionName) {
        this.sectionName = sectionName;
    }
    
    public int getRows() {
        return rows;
    }
    
    public void setRows(int rows) {
        this.rows = rows;
    }
    
    public int getSeatsPerRow() {
        return seatsPerRow;
    }
    
    public void setSeatsPerRow(int seatsPerRow) {
        this.seatsPerRow = seatsPerRow;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public String getRowStartLabel() {
        return rowStartLabel;
    }
    
    public void setRowStartLabel(String rowStartLabel) {
        this.rowStartLabel = rowStartLabel;
    }
}

