package com.dao;

import com.dto.User;
import com.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for User entity
 * Handles all database operations related to users
 */
public class UserDao {

    // SQL Queries
    private static final String INSERT_USER = "INSERT INTO users (name, password, email, otp, is_verified) VALUES (?, ?, ?, ?, ?)";
    private static final String GET_USER_BY_EMAIL = "SELECT * FROM users WHERE email = ?";
    private static final String GET_USER_BY_ID = "SELECT * FROM users WHERE id = ?";
    private static final String GET_USER_BY_EMAIL_AND_PASSWORD = "SELECT * FROM users WHERE email = ? AND password = ?";
    private static final String UPDATE_OTP = "UPDATE users SET otp = ? WHERE email = ?";
    private static final String VERIFY_USER = "UPDATE users SET is_verified = TRUE WHERE email = ?";
    private static final String GET_ALL_USERS = "SELECT * FROM users";
    private static final String DELETE_USER = "DELETE FROM users WHERE id = ?";
    private static final String UPDATE_PASSWORD = "UPDATE users SET password = ? WHERE email = ?";

    /**
     * Register a new user
     * @param user User object to register
     * @return true if registration successful, false otherwise
     */
    public boolean registerUser(User user) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(INSERT_USER, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getEmail());
            pstmt.setInt(4, user.getOtp());
            pstmt.setBoolean(5, user.isVerified());
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    user.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get user by email
     * @param email User's email
     * @return User object if found, null otherwise
     */
    public User getUserByEmail(String email) {
        User user = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_USER_BY_EMAIL)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    /**
     * Get user by ID
     * @param id User's ID
     * @return User object if found, null otherwise
     */
    public User getUserById(int id) {
        User user = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_USER_BY_ID)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    /**
     * Authenticate user with email and password
     * @param email User's email
     * @param password User's password
     * @return User object if authentication successful, null otherwise
     */
    public User login(String email, String password) {
        User user = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_USER_BY_EMAIL_AND_PASSWORD)) {
            
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    /**
     * Update OTP for a user
     * @param email User's email
     * @param otp New OTP
     * @return true if update successful, false otherwise
     */
    public boolean updateOtp(String email, int otp) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_OTP)) {
            
            pstmt.setInt(1, otp);
            pstmt.setString(2, email);
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Verify user by email
     * @param email User's email
     * @return true if verification successful, false otherwise
     */
    public boolean verifyUser(String email) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(VERIFY_USER)) {
            
            pstmt.setString(1, email);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all users
     * @return List of all users
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_ALL_USERS)) {
            
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Delete user by ID
     * @param id User's ID
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteUser(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(DELETE_USER)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update user's password
     * @param email User's email
     * @param newPassword New password
     * @return true if update successful, false otherwise
     */
    public boolean updatePassword(String email, String newPassword) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_PASSWORD)) {
            
            pstmt.setString(1, newPassword);
            pstmt.setString(2, email);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Check if email already exists
     * @param email Email to check
     * @return true if email exists, false otherwise
     */
    public boolean emailExists(String email) {
        return getUserByEmail(email) != null;
    }

    /**
     * Helper method to extract User from ResultSet
     */
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setName(rs.getString("name"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setOtp(rs.getInt("otp"));
        user.setVerified(rs.getBoolean("is_verified"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}
