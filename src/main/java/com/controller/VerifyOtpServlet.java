package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Random;

import com.util.DBConnection;
import com.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for handling OTP verification and resend operations
 */
@WebServlet("/VerifyOtpServlet")
public class VerifyOtpServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private Random random = new Random();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        switch (action) {
            case "verifyOtp":
                handleVerifyOtp(request, response);
                break;
            case "resendOtp":
                handleResendOtp(request, response);
                break;
            default:
                response.sendRedirect("index.jsp");
        }
    }
    
    /**
     * Handle OTP verification
     */
    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("registrationEmail");
        
        if (email == null) {
            response.sendRedirect("user-signup.jsp?error=Session expired! Please register again.");
            return;
        }
        
        String otp = request.getParameter("otp");
        
        if (otp == null || otp.trim().isEmpty()) {
            request.setAttribute("error", "Please enter OTP!");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            return;
        }
        
        try (Connection con = DBConnection.getConnection()) {
            
            // Find valid OTP for this email
            String sql = "SELECT u.id FROM users u " +
                    "JOIN email_otps e ON u.id = e.user_id " +
                    "WHERE u.email = ? AND e.otp_code = ? " +
                    "AND e.expires_at > NOW() AND e.is_used = false";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, otp);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                long userId = rs.getLong("id");
                
                // Mark user as verified
                PreparedStatement updateUser = con.prepareStatement(
                        "UPDATE users SET is_verified = true WHERE id = ?");
                updateUser.setLong(1, userId);
                updateUser.executeUpdate();
                
                // Mark OTP as used
                PreparedStatement updateOtp = con.prepareStatement(
                        "UPDATE email_otps SET is_used = true WHERE user_id = ?");
                updateOtp.setLong(1, userId);
                updateOtp.executeUpdate();
                
                // Clear session attributes
                session.removeAttribute("registrationEmail");
                session.removeAttribute("registrationName");
                
                // Redirect to login with success message
                response.sendRedirect(request.getContextPath() + 
                        "/user-login.jsp?success=Email verified successfully! Please login.");
            } else {
                request.setAttribute("error", "Invalid or expired OTP!");
                request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Verification failed! Please try again.");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle resend OTP
     */
    private void handleResendOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("registrationEmail");
        
        if (email == null) {
            response.sendRedirect("user-signup.jsp?error=Session expired! Please register again.");
            return;
        }
        
        try (Connection con = DBConnection.getConnection()) {
            
            // Generate new OTP
            int newOtp = generateOtp();
            
            // Get user ID
            String userSql = "SELECT id FROM users WHERE email = ?";
            PreparedStatement userPs = con.prepareStatement(userSql);
            userPs.setString(1, email);
            ResultSet userRs = userPs.executeQuery();
            
            if (!userRs.next()) {
                response.sendRedirect("user-signup.jsp?error=User not found! Please register again.");
                return;
            }
            
            long userId = userRs.getLong("id");
            
            // Update OTP in database
            String updateSql = "UPDATE email_otps SET otp_code = ?, expires_at = ? " +
                    "WHERE user_id = ? AND is_used = false";
            PreparedStatement updatePs = con.prepareStatement(updateSql);
            updatePs.setString(1, String.valueOf(newOtp));
            updatePs.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now().plusMinutes(10)));
            updatePs.setLong(3, userId);
            updatePs.executeUpdate();
            
            // Send new OTP via email
            EmailUtil.sendOTP(email, String.valueOf(newOtp));
            
            response.sendRedirect(request.getContextPath() + 
                    "/verifyOtp.jsp?success=New OTP sent to your email!");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to resend OTP! Please try again.");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
        }
    }
    
    /**
     * Generate a 6-digit OTP
     */
    private int generateOtp() {
        return 100000 + random.nextInt(900000);
    }
}
