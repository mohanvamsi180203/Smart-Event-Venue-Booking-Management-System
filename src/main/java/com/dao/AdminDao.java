package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.dto.Admin;
import com.util.DBConnection;

/**
 * Data Access Object for Admin entity
 * Handles all database operations related to admin
 */
public class AdminDao {

    private static final String INSERT_ADMIN = "INSERT INTO admin (username, password, email, full_name) VALUES (?, ?, ?, ?)";
    private static final String GET_ADMIN_BY_USERNAME = "SELECT * FROM admin WHERE username = ?";
    private static final String GET_ADMIN_BY_ID = "SELECT * FROM admin WHERE id = ?";
    private static final String GET_ADMIN_BY_EMAIL = "SELECT * FROM admin WHERE email = ?";
    private static final String UPDATE_LAST_LOGIN = "UPDATE admin SET last_login = ? WHERE id = ?";
    private static final String GET_ALL_ADMINS = "SELECT * FROM admin";
    private static final String DELETE_ADMIN = "DELETE FROM admin WHERE id = ?";

    /**
     * Authenticate admin with username and password
     */
    public Admin login(String username, String password) {
        Admin admin = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_ADMIN_BY_USERNAME)) {
            
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                // Check if password matches (supports both hashed and plain text for testing)
                if (storedPassword.equals(password) || org.mindrot.jbcrypt.BCrypt.checkpw(password, storedPassword)) {
                    admin = extractAdminFromResultSet(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }

    /**
     * Get admin by username
     */
    public Admin getAdminByUsername(String username) {
        Admin admin = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_ADMIN_BY_USERNAME)) {
            
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                admin = extractAdminFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }

    /**
     * Get admin by ID
     */
    public Admin getAdminById(int id) {
        Admin admin = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_ADMIN_BY_ID)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                admin = extractAdminFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }

    /**
     * Update last login time
     */
    public boolean updateLastLogin(int adminId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_LAST_LOGIN)) {
            
            pstmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(2, adminId);
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all admins
     */
    public List<Admin> getAllAdmins() {
        List<Admin> admins = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_ALL_ADMINS)) {
            
            while (rs.next()) {
                admins.add(extractAdminFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admins;
    }

    /**
     * Check if username already exists
     */
    public boolean usernameExists(String username) {
        return getAdminByUsername(username) != null;
    }

    /**
     * Helper method to extract Admin from ResultSet
     */
    private Admin extractAdminFromResultSet(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setId(rs.getInt("id"));
        admin.setUsername(rs.getString("username"));
        admin.setPassword(rs.getString("password"));
        admin.setEmail(rs.getString("email"));
        admin.setFullName(rs.getString("full_name"));
        admin.setCreatedAt(rs.getTimestamp("created_at"));
        admin.setLastLogin(rs.getTimestamp("last_login"));
        return admin;
    }
}
