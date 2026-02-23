<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Login | EventHub</title>
        <link rel="stylesheet" href="css/user-style.css">
        <!-- Font Awesome for Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>

    <body>

        <div class="auth-wrapper">
            <div class="auth-card">
                <div class="auth-header">
                    <a href="index.jsp" class="logo">EventHub</a>
                    <h2>Welcome Back</h2>
                    <p>Enter your credentials to access your account</p>
                </div>

                <div class="auth-toggle">
                    <a href="user-login.jsp" class="active">User Access</a>
                    <a href="organizer-login.jsp">Organizer Access</a>
                </div>

                <%-- Success/Error Messages from Servlet --%>
                    <% if (request.getAttribute("error") !=null) { %>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <%= request.getAttribute("error") %>
                        </div>
                        <% } %>

                            <form action="UserLoginServlet" method="POST" class="auth-form">
                                <div class="form-group">
                                    <label for="email">Email Address</label>
                                    <div class="input-wrapper">
                                        <input type="email" id="email" name="email" placeholder="name@company.com"
                                            required>
                                        <i class="fas fa-envelope"></i>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="mobile">Mobile Number (Optional)</label>
                                    <div class="input-wrapper">
                                        <input type="tel" id="mobile" name="mobile" placeholder="+91 98765 43210">
                                        <i class="fas fa-phone"></i>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="password">Password</label>
                                    <div class="input-wrapper">
                                        <input type="password" id="password" name="password" placeholder="••••••••"
                                            required>
                                        <i class="fas fa-lock"></i>
                                    </div>
                                </div>

                                <div class="form-options">
                                    <label class="remember-me">
                                        <input type="checkbox" name="remember"> Remember me
                                    </label>
                                    <a href="forgot-password.jsp" class="forgot-password">Forgot password?</a>
                                </div>

                                <button type="submit" class="btn-auth">Sign In</button>
                            </form>

                            <div class="auth-footer">
                                Don't have an account? <a href="user-signup.jsp">Create Account</a>
                            </div>
            </div>
        </div>

    </body>

    </html>