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
    <title>Login - EventHub</title>
    <link rel="stylesheet" href="css/user-style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-card">
            <div class="auth-header">
                <a href="index.jsp" class="logo">EventHub</a>
                <h2>Welcome Back</h2>
                <p>Login to your account to continue</p>
            </div>

            <div class="auth-toggle">
                <a href="user-login.jsp" class="active">User Access</a>
                <a href="organizer-login.jsp">Organizer Access</a>
            </div>
            
            <%-- Display success message if any --%>
            <% String successParam = request.getParameter("success");
               if (successParam != null) { %>
                <div class="alert alert-success">
                    <%= successParam %>
                </div>
            <% } %>
            
            <%-- Display error message if any --%>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="UserServlet" method="post" class="auth-form" id="loginForm">
                <input type="hidden" name="action" value="login">
                
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
                               placeholder="Enter your password" 
                               required autocomplete="current-password">
                    </div>
                </div>
                
                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember"> Remember me
                    </label>
                    <a href="#" class="forgot-password">Forgot Password?</a>
                </div>
                
                <button type="submit" class="btn-auth">Login</button>
            </form>
            
            <div class="auth-footer">
                Don't have an account? <a href="user-signup.jsp">Register here</a>
            </div>
        </div>
    </div>
    
    <script>
        // Auto-focus on email field
        document.getElementById('email').focus();
    </script>
</body>
</html>
