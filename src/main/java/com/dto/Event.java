package com.dto;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.List;

/**
 * Event Data Transfer Object
 * Represents an event in the system
 */
public class Event {
    
    private int id;
    private String title;
    private String description;
    private int categoryId;
    private String categoryName; // For display purposes
    private int organizerId;
    private String organizerName; // For display purposes
    private String location;
    private String city;
    private String venueName;
    private Date eventDate;
    private Time eventTime;
    private BigDecimal durationHours;
    private String posterUrl;
    private BigDecimal ticketPrice;
    private int totalSeats;
    private int availableSeats;
    private String status; // pending, approved, rejected, cancelled
    private boolean isFeatured;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Dynamic sections for seat layout
    private List<Section> sections;
    
    // Default constructor
    public Event() {
    }
    
    // Constructor with essential fields
    public Event(String title, String description, int categoryId, int organizerId, 
                 String location, String city, String venueName, Date eventDate, 
                 Time eventTime, BigDecimal ticketPrice, int totalSeats) {
        this.title = title;
        this.description = description;
        this.categoryId = categoryId;
        this.organizerId = organizerId;
        this.location = location;
        this.city = city;
        this.venueName = venueName;
        this.eventDate = eventDate;
        this.eventTime = eventTime;
        this.ticketPrice = ticketPrice;
        this.totalSeats = totalSeats;
        this.availableSeats = totalSeats;
        this.status = "pending";
        this.isFeatured = false;
    }
    
    // Getter and Setter methods
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    
    public int getOrganizerId() { return organizerId; }
    public void setOrganizerId(int organizerId) { this.organizerId = organizerId; }
    
    public String getOrganizerName() { return organizerName; }
    public void setOrganizerName(String organizerName) { this.organizerName = organizerName; }
    
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    
    public String getVenueName() { return venueName; }
    public void setVenueName(String venueName) { this.venueName = venueName; }
    
    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }
    
    public Time getEventTime() { return eventTime; }
    public void setEventTime(Time eventTime) { this.eventTime = eventTime; }
    
    public BigDecimal getDurationHours() { return durationHours; }
    public void setDurationHours(BigDecimal durationHours) { this.durationHours = durationHours; }
    
    public String getPosterUrl() { return posterUrl; }
    public void setPosterUrl(String posterUrl) { this.posterUrl = posterUrl; }
    
    public BigDecimal getTicketPrice() { return ticketPrice; }
    public void setTicketPrice(BigDecimal ticketPrice) { this.ticketPrice = ticketPrice; }
    
    public int getTotalSeats() { return totalSeats; }
    public void setTotalSeats(int totalSeats) { this.totalSeats = totalSeats; }
    
    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public boolean isFeatured() { return isFeatured; }
    public void setFeatured(boolean featured) { isFeatured = featured; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    // Sections for dynamic seat layout
    public List<Section> getSections() { return sections; }
    public void setSections(List<Section> sections) { this.sections = sections; }
    
    @Override
    public String toString() {
        return "Event{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", city='" + city + '\'' +
                ", eventDate=" + eventDate +
                ", status='" + status + '\'' +
                '}';
    }
}
