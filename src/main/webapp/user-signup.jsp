<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Account | EventHub</title>
        <link rel="stylesheet" href="css/user-style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>

    <body>

        <div class="auth-wrapper">
            <div class="auth-card">
                <div class="auth-header">
                    <a href="index.jsp" class="logo">EventHub</a>
                    <h2>Create Account</h2>
                    <p>Join our community of event enthusiasts today</p>
                </div>
  
                <div class="auth-toggle">
                    <a href="user-signup.jsp" class="active">User Signup</a>
                    <a href="organizer-signup.jsp">Organizer Signup</a>
                </div>

                <%-- Success/Error Messages from Servlet --%>
                    <% if (request.getAttribute("error") !=null) { %>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <%= request.getAttribute("error") %>
                        </div>
                        <% } %>
                            <% if (request.getAttribute("success") !=null) { %>
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle"></i>
                                    <%= request.getAttribute("success") %>
                                </div>
                                <% } %>

<form action="UserServlet" method="POST" class="auth-form">
    <input type="hidden" name="action" value="register">
                                        <div class="form-group">
                                            <label for="name">Full Name</label>
                                            <div class="input-wrapper">
                                                <input type="text" id="name" name="name" placeholder="John Doe"
                                                    required>
                                                <i class="fas fa-user"></i>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label for="email">Email Address</label>
                                            <div class="input-wrapper">
                                                <input type="email" id="email" name="email"
                                                    placeholder="john@example.com" required>
                                                <i class="fas fa-envelope"></i>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label for="mobile">Mobile Number</label>
                                            <div class="input-wrapper">
                                                <input type="tel" id="mobile" name="mobile"
                                                    placeholder="+91 98765 43210" required>
                                                <i class="fas fa-phone"></i>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label for="password">Password</label>
                                            <div class="input-wrapper">
                                                <input type="password" id="password" name="password"
                                                    placeholder="Min. 8 characters" required minlength="8">
                                                <i class="fas fa-lock"></i>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label for="confirmPassword">Confirm Password</label>
                                            <div class="input-wrapper">
                                                <input type="password" id="confirmPassword" name="confirmPassword"
                                                    placeholder="••••••••" required>
                                                <i class="fas fa-shield-alt"></i>
                                            </div>
                                        </div>

                                        <button type="submit" class="btn-auth">Create Account</button>
                                    </form>

                                    <div class="auth-footer">
                                        Already have an account? <a href="user-login.jsp">Login here</a>
                                    </div>
            </div>
        </div>

    </body>

    </html>