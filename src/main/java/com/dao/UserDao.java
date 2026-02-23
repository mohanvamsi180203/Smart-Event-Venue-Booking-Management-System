package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.dto.User;
import com.util.DBUtil;

/**
 * Data Access Object for User operations
 * Handles all database operations related to user registration and verification
 */
public class UserDao {
    
    /**
     * Save a new user to the database with OTP
     * @param user User object to save
     * @return true if user was saved successfully, false otherwise
     */
    public boolean saveUser(User user) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        String sql = "INSERT INTO users (name, password, email, otp, is_verified, created_at) VALUES (?, ?, ?, ?, false, CURRENT_TIMESTAMP)";
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getEmail());
            pstmt.setInt(4, user.getOtp());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt);
        }
    }
    
    /**
     * Get user by email
     * @param email User's email address
     * @return User object if found, null otherwise
     */
    public User getUserByEmail(String email) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return null;
    }
    
    /**
     * Get user by ID
     * @param id User's ID
     * @return User object if found, null otherwise
     */
    public User getUserById(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM users WHERE id = ?";
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return null;
    }
    
    /**
     * Update user's OTP
     * @param email User's email
     * @param newOtp New OTP to set
     * @return true if updated successfully, false otherwise
     */
    public boolean updateOtp(String email, int newOtp) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        String sql = "UPDATE users SET otp = ? WHERE email = ?";
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setInt(1, newOtp);
            pstmt.setString(2, email);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt);
        }
    }
    
    /**
     * Update verification status
     * @param email User's email
     * @return true if updated successfully, false otherwise
     */
    public boolean updateVerificationStatus(String email) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        String sql = "UPDATE users SET is_verified = true, otp = 0 WHERE email = ?";
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, email);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt);
        }
    }
    
    /**
     * Verify user by email and OTP
     * @param email User's email
     * @param otp One-time password to verify
     * @return true if OTP matches and user is verified, false otherwise
     */
    public boolean verifyOtp(String email, int otp) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        String sql = "UPDATE users SET is_verified = true WHERE email = ? AND otp = ?";
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, email);
            pstmt.setInt(2, otp);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt);
        }
    }
    
    /**
     * Check if email already exists
     * @param email Email to check
     * @return true if email exists, false otherwise
     */
    public boolean emailExists(String email) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return false;
    }
    
    /**
     * Authenticate user - login with email and password
     * @param email User's email
     * @param password User's password
     * @return User object if authentication successful, null otherwise
     */
    public User authenticateUser(String email, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return null;
    }
    
    /**
     * Validate user login (requires verified account)
     * @param email User's email
     * @param password User's password
     * @return User object if login successful, null otherwise
     */
    public User login(String email, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM users WHERE email = ? AND password = ? AND is_verified = true";
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return null;
    }
    
    /**
     * Extract user data from ResultSet
     * @param rs ResultSet containing user data
     * @return User object
     * @throws SQLException if database access error occurs
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
    
    /**
     * Close database resources
     * @param conn Connection to close
     * @param pstmt PreparedStatement to close
     */
    private void closeResources(Connection conn, PreparedStatement pstmt) {
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        DBUtil.closeConnection(conn);
    }
    
    /**
     * Close database resources including ResultSet
     * @param conn Connection to close
     * @param pstmt PreparedStatement to close
     * @param rs ResultSet to close
     */
    private void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        closeResources(conn, pstmt);
    }
}
