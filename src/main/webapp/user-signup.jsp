<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is already logged in
    if (session.getAttribute("userId") != null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - EventHub</title>
    <link rel="stylesheet" href="css/user-style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-card">
            <div class="auth-header">
                <a href="index.jsp" class="logo">EventHub</a>
                <h2>Create Account</h2>
                <p>Join us and start booking amazing events</p>
            </div>

            <div class="auth-toggle">
                <a href="user-signup.jsp" class="active">User Access</a>
                <a href="organizer-signup.jsp">Organizer Access</a>
            </div>
            
            <%-- Display error message if any --%>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="UserServlet" method="post" class="auth-form" id="registerForm">
                <input type="hidden" name="action" value="register">
                
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <div class="input-wrapper">
                        <i>👤</i>
                        <input type="text" id="name" name="name" 
                               placeholder="Enter your full name" 
                               required autocomplete="name">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-wrapper">
                        <i>📧</i>
                        <input type="email" id="email" name="email" 
                               placeholder="Enter your email" 
                               required autocomplete="email">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <i>🔒</i>
                        <input type="password" id="password" name="password" 
                               placeholder="Create a password" 
                               required autocomplete="new-password">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <div class="input-wrapper">
                        <i>🔒</i>
                        <input type="password" id="confirmPassword" name="confirmPassword" 
                               placeholder="Confirm your password" 
                               required autocomplete="new-password">
                    </div>
                </div>
                
                <button type="submit" class="btn-auth">Register</button>
            </form>
            
            <div class="auth-footer">
                Already have an account? <a href="user-login.jsp">Login here</a>
            </div>
        </div>
    </div>
    
    <script>
        // Client-side validation
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            var password = document.getElementById('password').value;
            var confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters!');
                return false;
            }
            
            return true;
        });
    </script>
</body>
</html>
