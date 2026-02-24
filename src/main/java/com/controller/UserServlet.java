package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Random;

import org.mindrot.jbcrypt.BCrypt;

import com.util.DBConnection;
import com.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private Random random = new Random();
    
    // Action constants
    private static final String ACTION_REGISTER = "register";
    private static final String ACTION_VERIFY_OTP = "verifyOtp";
    private static final String ACTION_RESEND_OTP = "resendOtp";
    private static final String ACTION_LOGIN = "login";
    private static final String ACTION_LOGOUT = "logout";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        switch (action) {
            case ACTION_REGISTER:
                handleRegistration(request, response);
                break;
            case ACTION_VERIFY_OTP:
                handleOtpVerification(request, response);
                break;
            case ACTION_RESEND_OTP:
                handleResendOtp(request, response);
                break;
            case ACTION_LOGIN:
                handleLogin(request, response);
                break;
            default:
                response.sendRedirect("index.jsp");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (ACTION_LOGOUT.equals(action)) {
            handleLogout(request, response);
        } else {
            response.sendRedirect("index.jsp");
        }
    }
    
    /**
     * Handle user registration
     */
    private void handleRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher("user-signup.jsp").forward(request, response);
            return;
        }
        
        // Check password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("user-signup.jsp").forward(request, response);
            return;
        }
        
        // Check password length
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters!");
            request.getRequestDispatcher("user-signup.jsp").forward(request, response);
            return;
        }
        
        try (Connection con = DBConnection.getConnection()) {
            
            // Check if email already exists
            String checkSql = "SELECT id FROM users WHERE email = ?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, email);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                request.setAttribute("error", "Email already registered!");
                request.getRequestDispatcher("user-signup.jsp").forward(request, response);
                return;
            }
            
            // Hash password
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            
            // Generate OTP
            int otp = generateOtp();
            
            // Calculate expiration time - 10 minutes from now (using current timestamp)
            long expirationTime = System.currentTimeMillis() + (10 * 60 * 1000);
            
            // Insert user with OTP directly in users table
            String sql = "INSERT INTO users (name, password, email, otp, otp_expires_at, is_verified) VALUES (?, ?, ?, ?, ?, false)";
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, name);
            ps.setString(2, hashedPassword);
            ps.setString(3, email);
            ps.setInt(4, otp);
            ps.setTimestamp(5, new Timestamp(expirationTime));
            ps.executeUpdate();
            
            // Debug: Print OTP to console
            System.out.println("===== OTP for " + email + " : " + otp + " =====");
            
            // Send OTP via email
            EmailUtil.sendOTP(email, String.valueOf(otp));
            
            // Store email in session
            HttpSession session = request.getSession();
            session.setAttribute("registrationEmail", email);
            session.setAttribute("registrationName", name);
            
            // Redirect to verification page
            response.sendRedirect(request.getContextPath() + "/verifyOtp.jsp?email=" + email);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed! Please try again.");
            request.getRequestDispatcher("user-signup.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle OTP verification
     */
    private void handleOtpVerification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("registrationEmail");
        
        if (email == null) {
            response.sendRedirect("user-signup.jsp?error=Session expired! Please register again.");
            return;
        }
        
        String otpInput = request.getParameter("otp");
        
        if (otpInput == null || otpInput.trim().isEmpty()) {
            request.setAttribute("error", "Please enter OTP!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            return;
        }
        
        try {
            int otp = Integer.parseInt(otpInput);
            long currentTime = System.currentTimeMillis();
            
            try (Connection con = DBConnection.getConnection()) {
            
                // Check OTP and expiration in users table - compare timestamps
                String sql = "SELECT id, otp, otp_expires_at FROM users WHERE email=? AND is_verified=false";
                
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, email);
                
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    int storedOtp = rs.getInt("otp");
                    Timestamp expiryTime = rs.getTimestamp("otp_expires_at");
                    
                    System.out.println("Stored OTP: " + storedOtp + ", Entered OTP: " + otp);
                    System.out.println("Current Time: " + currentTime + ", Expiry: " + (expiryTime != null ? expiryTime.getTime() : "null"));
                    
                    if (storedOtp == otp && expiryTime != null && currentTime < expiryTime.getTime()) {
                        long userId = rs.getLong("id");
                        String userName = (String) session.getAttribute("registrationName");
                        
                        // Mark user as verified and clear OTP
                        PreparedStatement updateUser = con.prepareStatement(
                                "UPDATE users SET is_verified=true, otp=NULL, otp_expires_at=NULL WHERE id=?");
                        updateUser.setLong(1, userId);
                        updateUser.executeUpdate();
                        
                        // Send registration success email
                        try {
                            EmailUtil.sendRegistrationSuccess(email, userName);
                            System.out.println("===== Registration success email sent to " + email + " =====");
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        
                        // Clear session
                        session.removeAttribute("registrationEmail");
                        session.removeAttribute("registrationName");
                        
                        // Redirect to login with success message
                        response.sendRedirect(request.getContextPath() + "/user-login.jsp?success=Email verified successfully! Please login.");
                    } else {
                        request.setAttribute("error", "Invalid or expired OTP!");
                        request.setAttribute("email", email);
                        request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Invalid or expired OTP!");
                    request.setAttribute("email", email);
                    request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
                }
                
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Please enter a valid numeric OTP!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Verification failed! Please try again.");
            request.setAttribute("email", email);
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
            
            // Calculate new expiration time
            long expirationTime = System.currentTimeMillis() + (10 * 60 * 1000);
            
            // Update OTP in users table
            String updateSql = "UPDATE users SET otp=?, otp_expires_at=? WHERE email=? AND is_verified=false";
            PreparedStatement updatePs = con.prepareStatement(updateSql);
            updatePs.setInt(1, newOtp);
            updatePs.setTimestamp(2, new Timestamp(expirationTime));
            updatePs.setString(3, email);
            updatePs.executeUpdate();
            
            // Debug: Print OTP to console
            System.out.println("===== New OTP for " + email + " : " + newOtp + " =====");
            
            // Send new OTP via email
            EmailUtil.sendOTP(email, String.valueOf(newOtp));
            
            response.sendRedirect(request.getContextPath() + "/verifyOtp.jsp?success=New OTP sent to your email!&email=" + email);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to resend OTP! Please try again.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle user login
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validation
        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher("user-login.jsp").forward(request, response);
            return;
        }
        
        try (Connection con = DBConnection.getConnection()) {
            
            String sql = "SELECT * FROM users WHERE email = ? AND is_verified = true";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                
                if (BCrypt.checkpw(password, hashedPassword)) {
                    // Login successful
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("userName", rs.getString("name"));
                    session.setAttribute("userEmail", rs.getString("email"));
                    
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                    return;
                } else {
                    request.setAttribute("error", "Invalid password!");
                    request.getRequestDispatcher("user-login.jsp").forward(request, response);
                    return;
                }
            }
            
            // Check if email exists but not verified
            String checkSql = "SELECT id FROM users WHERE email = ?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, email);
            ResultSet checkRs = checkPs.executeQuery();
            
            if (checkRs.next()) {
                // Email exists but not verified
                response.sendRedirect(request.getContextPath() + "/verifyOtp.jsp?email=" + email + "&error=Email not verified! Please verify your email.");
            } else {
                request.setAttribute("error", "Email not registered!");
                request.getRequestDispatcher("user-login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Login failed! Please try again.");
            request.getRequestDispatcher("user-login.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle logout
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
    
    /**
     * Generate a 6-digit OTP
     */
    private int generateOtp() {
        return 100000 + random.nextInt(900000);
    }
}
