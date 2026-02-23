package com.controller;

import java.io.IOException;

import com.dao.UserDao;
import com.dto.User;
import com.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * UserServlet handles user registration, login, and OTP verification
 * Maps to /UserServlet URL
 */
public class UserServlet extends HttpServlet {
    
    private UserDao userDao;
    
    @Override
    public void init() throws ServletException {
        userDao = new UserDao();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("register".equals(action)) {
            registerUser(request, response);
        } else if ("verifyOtp".equals(action)) {
            verifyOtp(request, response);
        } else if ("login".equals(action)) {
            loginUser(request, response);
        } else {
            response.sendRedirect("user-login.jsp");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("index.jsp");
        } else {
            response.sendRedirect("index.jsp");
        }
    }
    
    private void registerUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("user-signup.jsp").forward(request, response);
            return;
        }
        
        // Check if email already exists
        User existingUser = userDao.getUserByEmail(email);
        if (existingUser != null) {
            request.setAttribute("error", "Email already registered");
            request.getRequestDispatcher("user-signup.jsp").forward(request, response);
            return;
        }
        
        // Generate OTP
        int otp = (int) ((Math.random() * 900000) + 100000);
        
        // Create user
        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setOtp(otp);
        
        // Save user to database
        boolean saved = userDao.saveUser(user);
        
        if (saved) {
            // Send OTP email
            boolean emailSent = EmailUtil.sendOtpEmail(email, otp, name);
            
            if (emailSent) {
                // Store email in session for verification - use registrationEmail to match verifyOtp.jsp
                HttpSession session = request.getSession();
                session.setAttribute("registrationEmail", email);
                response.sendRedirect("verifyOtp.jsp");
            } else {
                request.setAttribute("error", "Failed to send OTP email. Please try again.");
                request.getRequestDispatcher("user-signup.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("user-signup.jsp").forward(request, response);
        }
    }
    
    private void verifyOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("registrationEmail");
        
        if (email == null) {
            response.sendRedirect("user-signup.jsp?error=Session expired! Please register again.");
            return;
        }
        
        String otpStr = request.getParameter("otp");
        
        if (otpStr == null || otpStr.trim().isEmpty()) {
            request.setAttribute("error", "Please enter the OTP");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            return;
        }
        
        int enteredOtp;
        try {
            enteredOtp = Integer.parseInt(otpStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid OTP format. Please enter a 6-digit number.");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            return;
        }
        
        // Get user by email
        User user = userDao.getUserByEmail(email);
        
        if (user != null && user.getOtp() == enteredOtp) {
            // Update user as verified
            boolean updated = userDao.updateVerificationStatus(email);
            
            if (updated) {
                // Send welcome email
                EmailUtil.sendWelcomeEmail(email, user.getName());
                
                // Create session and store user
                HttpSession newSession = request.getSession();
                newSession.setAttribute("user", user);
                newSession.setAttribute("userEmail", email);
                newSession.setAttribute("userName", user.getName());
                newSession.setAttribute("userId", user.getId());
                
                response.sendRedirect("index.jsp");
            } else {
                request.setAttribute("error", "Verification failed. Please try again.");
                request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Invalid OTP. Please try again.");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
        }
    }
    
    private void loginUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validation
        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("user-login.jsp").forward(request, response);
            return;
        }
        
        // Authenticate user
        User user = userDao.authenticateUser(email, password);
        
        if (user != null) {
            if (user.isVerified()) {
                // Create session and store user
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userEmail", email);
                session.setAttribute("userName", user.getName());
                session.setAttribute("userId", user.getId());
                
                response.sendRedirect("index.jsp");
            } else {
                // Resend OTP for unverified users
                int otp = (int) ((Math.random() * 900000) + 100000);
                userDao.updateOtp(email, otp);
                EmailUtil.sendOtpEmail(email, otp, user.getName());
                
                HttpSession session = request.getSession();
                session.setAttribute("registrationEmail", email);
                response.sendRedirect("verifyOtp.jsp");
            }
        } else {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("user-login.jsp").forward(request, response);
        }
    }
}
