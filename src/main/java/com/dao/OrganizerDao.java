package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.dto.Organizer;
import com.util.DBConnection;

/**
 * Data Access Object for Organizer entity
 * Handles all database operations related to organizers
 */
public class OrganizerDao {

    // SQL Queries
    private static final String INSERT_ORGANIZER = "INSERT INTO organizer (name, email, password, phone, company_name, address, status, is_verified) VALUES (?, ?, ?, ?, ?, ?, 'pending', false)";
    private static final String GET_ORGANIZER_BY_EMAIL = "SELECT * FROM organizer WHERE email = ?";
    private static final String GET_ORGANIZER_BY_ID = "SELECT * FROM organizer WHERE id = ?";
    private static final String GET_ORGANIZER_BY_EMAIL_AND_PASSWORD = "SELECT * FROM organizer WHERE email = ? AND password = ?";
    private static final String GET_ALL_ORGANIZERS = "SELECT * FROM organizer ORDER BY created_at DESC";
    private static final String GET_ORGANIZERS_BY_STATUS = "SELECT * FROM organizer WHERE status = ? ORDER BY created_at DESC";
    private static final String UPDATE_ORGANIZER_STATUS = "UPDATE organizer SET status = ?, approved_by = ?, approved_at = ? WHERE id = ?";
    private static final String UPDATE_ORGANIZER = "UPDATE organizer SET name = ?, phone = ?, company_name = ?, address = ? WHERE id = ?";
    private static final String DELETE_ORGANIZER = "DELETE FROM organizer WHERE id = ?";
    private static final String GET_PENDING_COUNT = "SELECT COUNT(*) FROM organizer WHERE status = 'pending'";
    private static final String GET_APPROVED_COUNT = "SELECT COUNT(*) FROM organizer WHERE status = 'approved'";

    /**
     * Register a new organizer
     */
    public boolean registerOrganizer(Organizer organizer) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(INSERT_ORGANIZER, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, organizer.getName());
            pstmt.setString(2, organizer.getEmail());
            pstmt.setString(3, organizer.getPassword());
            pstmt.setString(4, organizer.getPhone());
            pstmt.setString(5, organizer.getCompanyName());
            pstmt.setString(6, organizer.getAddress());
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    organizer.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get organizer by email
     */
    public Organizer getOrganizerByEmail(String email) {
        Organizer organizer = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_ORGANIZER_BY_EMAIL)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                organizer = extractOrganizerFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return organizer;
    }

    /**
     * Get organizer by ID
     */
    public Organizer getOrganizerById(int id) {
        Organizer organizer = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_ORGANIZER_BY_ID)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                organizer = extractOrganizerFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return organizer;
    }

    /**
     * Authenticate organizer with email and password
     */
    public Organizer login(String email, String password) {
        Organizer organizer = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_ORGANIZER_BY_EMAIL_AND_PASSWORD)) {
            
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                organizer = extractOrganizerFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return organizer;
    }

    /**
     * Get all organizers
     */
    public List<Organizer> getAllOrganizers() {
        List<Organizer> organizers = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_ALL_ORGANIZERS)) {
            
            while (rs.next()) {
                organizers.add(extractOrganizerFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return organizers;
    }

    /**
     * Get organizers by status
     */
    public List<Organizer> getOrganizersByStatus(String status) {
        List<Organizer> organizers = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_ORGANIZERS_BY_STATUS)) {
            
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                organizers.add(extractOrganizerFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return organizers;
    }

    /**
     * Approve or reject organizer
     */
    public boolean updateStatus(int organizerId, String status, int adminId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_ORGANIZER_STATUS)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, adminId);
            pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(4, organizerId);
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update organizer details
     */
    public boolean updateOrganizer(Organizer organizer) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_ORGANIZER)) {
            
            pstmt.setString(1, organizer.getName());
            pstmt.setString(2, organizer.getPhone());
            pstmt.setString(3, organizer.getCompanyName());
            pstmt.setString(4, organizer.getAddress());
            pstmt.setInt(5, organizer.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete organizer
     */
    public boolean deleteOrganizer(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(DELETE_ORGANIZER)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get count of pending organizers
     */
    public int getPendingCount() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_PENDING_COUNT)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get count of approved organizers
     */
    public int getApprovedCount() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_APPROVED_COUNT)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Check if email already exists
     */
    public boolean emailExists(String email) {
        return getOrganizerByEmail(email) != null;
    }

    /**
     * Helper method to extract Organizer from ResultSet
     */
    private Organizer extractOrganizerFromResultSet(ResultSet rs) throws SQLException {
        Organizer organizer = new Organizer();
        organizer.setId(rs.getInt("id"));
        organizer.setName(rs.getString("name"));
        organizer.setEmail(rs.getString("email"));
        organizer.setPassword(rs.getString("password"));
        organizer.setPhone(rs.getString("phone"));
        organizer.setCompanyName(rs.getString("company_name"));
        organizer.setAddress(rs.getString("address"));
        organizer.setStatus(rs.getString("status"));
        organizer.setVerified(rs.getBoolean("is_verified"));
        organizer.setCreatedAt(rs.getTimestamp("created_at"));
        organizer.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        int approvedBy = rs.getInt("approved_by");
        if (!rs.wasNull()) {
            organizer.setApprovedBy(approvedBy);
        }
        organizer.setApprovedAt(rs.getTimestamp("approved_at"));
        
        return organizer;
    }
}
