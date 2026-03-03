<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Organizer Registration | EventHub</title>
    <link rel="stylesheet" href="css/user-style.css">
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <div class="auth-wrapper">
        <div class="auth-card">
            <div class="auth-header">
                <a href="index.jsp" class="logo">EventHub</a>
                <h2>Organizer Registration</h2>
                <p>Create your organizer account</p>
            </div>

            <div class="auth-toggle">
                <a href="user-login.jsp">User Access</a>
                <a href="organizer-login.jsp">Organizer Access</a>
            </div>

            <% 
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= error %>
                </div>
            <% 
                }
            %>
            
            <form action="OrganizerServlet" method="POST" class="auth-form">
                <input type="hidden" name="action" value="register">
                
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <div class="input-wrapper">
                        <input type="text" id="name" name="name" placeholder="Enter your full name" required>
                        <i class="fas fa-user"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-wrapper">
                        <input type="email" id="email" name="email" placeholder="name@company.com" required>
                        <i class="fas fa-envelope"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <div class="input-wrapper">
                        <input type="tel" id="phone" name="phone" placeholder="Enter phone number">
                        <i class="fas fa-phone"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="companyName">Company/Organization Name</label>
                    <div class="input-wrapper">
                        <input type="text" id="companyName" name="companyName" placeholder="Enter company name">
                        <i class="fas fa-building"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="address">Address</label>
                    <div class="input-wrapper">
                        <textarea id="address" name="address" rows="2" placeholder="Enter address"></textarea>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password" placeholder="Minimum 6 characters" required>
                        <i class="fas fa-lock"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter password" required>
                        <i class="fas fa-lock"></i>
                    </div>
                </div>
                
                <button type="submit" class="btn-auth">Register</button>
            </form>
            
            <div class="auth-footer">
                Already registered? <a href="organizer-login.jsp">Login here</a>
            </div>
        </div>
    </div>

</body>
</html>
