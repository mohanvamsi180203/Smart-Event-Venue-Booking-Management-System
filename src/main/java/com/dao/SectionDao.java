package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.dto.Section;
import com.util.DBConnection;

public class SectionDao {
    
    /**
     * Insert a section for an event
     */
    public int insert(Section section) throws Exception {
        String sql = "INSERT INTO sections (event_id, section_name, rows, seats_per_row, price, row_start_label) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, section.getEventId());
            ps.setString(2, section.getSectionName());
            ps.setInt(3, section.getRows());
            ps.setInt(4, section.getSeatsPerRow());
            ps.setBigDecimal(5, section.getPrice());
            ps.setString(6, section.getRowStartLabel() != null ? section.getRowStartLabel() : "A");
            
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Insert multiple sections for an event
     */
    public void insertSections(int eventId, List<Section> sections) throws Exception {
        String sql = "INSERT INTO sections (event_id, section_name, rows, seats_per_row, price, row_start_label) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (Section section : sections) {
                ps.setInt(1, eventId);
                ps.setString(2, section.getSectionName());
                ps.setInt(3, section.getRows());
                ps.setInt(4, section.getSeatsPerRow());
                ps.setBigDecimal(5, section.getPrice());
                ps.setString(6, section.getRowStartLabel() != null ? section.getRowStartLabel() : "A");
                ps.addBatch();
            }
            
            ps.executeBatch();
        }
    }
    
    /**
     * Get all sections for an event
     */
    public List<Section> getSectionsByEventId(int eventId) throws Exception {
        List<Section> sections = new ArrayList<>();
        String sql = "SELECT * FROM sections WHERE event_id = ? ORDER BY id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, eventId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Section section = extractSectionFromResultSet(rs);
                    sections.add(section);
                }
            }
        }
        return sections;
    }
    
    /**
     * Get a single section by ID
     */
    public Section getSectionById(int sectionId) throws Exception {
        String sql = "SELECT * FROM sections WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, sectionId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractSectionFromResultSet(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Update a section
     */
    public boolean update(Section section) throws Exception {
        String sql = "UPDATE sections SET section_name = ?, rows = ?, seats_per_row = ?, price = ?, row_start_label = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, section.getSectionName());
            ps.setInt(2, section.getRows());
            ps.setInt(3, section.getSeatsPerRow());
            ps.setBigDecimal(4, section.getPrice());
            ps.setString(5, section.getRowStartLabel());
            ps.setInt(6, section.getId());
            
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Delete a section by ID
     */
    public boolean delete(int sectionId) throws Exception {
        String sql = "DELETE FROM sections WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, sectionId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Delete all sections for an event
     */
    public boolean deleteByEventId(int eventId) throws Exception {
        String sql = "DELETE FROM sections WHERE event_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, eventId);
            return ps.executeUpdate() >= 0;
        }
    }
    
    /**
     * Generate seats automatically from section configurations
     * This method creates seats in the event_seats table based on section definitions
     */
    public void generateSeatsFromSections(int eventId) throws Exception {
        List<Section> sections = getSectionsByEventId(eventId);
        
        if (sections.isEmpty()) {
            return; // No sections defined, no seats to generate
        }
        
        // Clear existing seats for this event
        String deleteSql = "DELETE FROM event_seats WHERE event_id = ?";
        String insertSql = "INSERT INTO event_seats (event_id, seat_number, row_label, seat_column, section_id, status) VALUES (?, ?, ?, ?, ?, 'AVAILABLE')";
        
        try (Connection conn = DBConnection.getConnection()) {
            // Delete existing seats
            try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                ps.setInt(1, eventId);
                ps.executeUpdate();
            }
            
            // Generate new seats from sections
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                for (Section section : sections) {
                    generateSeatsForSection(conn, ps, eventId, section);
                }
            }
        }
    }
    
    /**
     * Generate seats for a single section
     */
    private void generateSeatsForSection(Connection conn, PreparedStatement ps, int eventId, Section section) throws SQLException {
        int sectionId = section.getId();
        int rows = section.getRows();
        int seatsPerRow = section.getSeatsPerRow();
        String startLabel = section.getRowStartLabel();
        
        // Calculate starting row number from label (A=1, B=2, etc.)
        int startRowNum = 1;
        if (startLabel != null && !startLabel.isEmpty()) {
            char c = startLabel.toUpperCase().charAt(0);
            if (c >= 'A' && c <= 'Z') {
                startRowNum = c - 'A' + 1;
            } else if (c >= '0' && c <= '9') {
                startRowNum = Integer.parseInt(startLabel);
            }
        }
        
        for (int row = 0; row < rows; row++) {
            // Calculate row label
            int currentRowNum = startRowNum + row;
            String rowLabel;
            if (currentRowNum <= 26) {
                rowLabel = String.valueOf((char) ('A' + currentRowNum - 1));
            } else {
                // For rows beyond Z, use A1, A2, etc.
                rowLabel = "A" + currentRowNum;
            }
            
            for (int seat = 1; seat <= seatsPerRow; seat++) {
                String seatNumber = rowLabel + seat;
                
                ps.setInt(1, eventId);
                ps.setString(2, seatNumber);
                ps.setString(3, rowLabel);
                ps.setInt(4, seat);
                ps.setInt(5, sectionId);
                
                ps.addBatch();
            }
        }
        
        ps.executeBatch();
    }
    
    /**
     * Calculate total seats from all sections
     */
    public int getTotalSeatsFromSections(int eventId) throws Exception {
        List<Section> sections = getSectionsByEventId(eventId);
        int total = 0;
        for (Section section : sections) {
            total += section.getTotalSeats();
        }
        return total;
    }
    
    /**
     * Extract Section from ResultSet
     */
    private Section extractSectionFromResultSet(ResultSet rs) throws SQLException {
        Section section = new Section();
        section.setId(rs.getInt("id"));
        section.setEventId(rs.getInt("event_id"));
        section.setSectionName(rs.getString("section_name"));
        section.setRows(rs.getInt("rows"));
        section.setSeatsPerRow(rs.getInt("seats_per_row"));
        section.setPrice(rs.getBigDecimal("price"));
        section.setRowStartLabel(rs.getString("row_start_label"));
        return section;
    }
}

