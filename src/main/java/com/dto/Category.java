package com.dto;

import java.sql.Timestamp;

/**
 * Category Data Transfer Object
 * Represents an event category in the system
 */
public class Category {
    
    private int id;
    private String name;
    private String description;
    private String icon;
    private boolean isActive;
    private Timestamp createdAt;
    
    // Default constructor
    public Category() {
    }
    
    // Constructor with essential fields
    public Category(String name, String description, String icon) {
        this.name = name;
        this.description = description;
        this.icon = icon;
        this.isActive = true;
    }
    
    // Full constructor
    public Category(int id, String name, String description, String icon, boolean isActive, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.icon = icon;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }
    
    // Getter and Setter methods
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", icon='" + icon + '\'' +
                ", isActive=" + isActive +
                '}';
    }
}
