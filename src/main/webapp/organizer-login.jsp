<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Organizer Login | EventHub</title>
        <link rel="stylesheet" href="css/user-style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>

    <body>

        <div class="auth-wrapper">
            <div class="auth-card">
                <div class="auth-header">
                    <a href="index.jsp" class="logo">EventHub</a>
                    <h2>Organizer Portal</h2>
                    <p>Manage your venues and events effectively</p>
                </div>

                <div class="auth-toggle">
                    <a href="user-login.jsp">User Access</a>
                    <a href="organizer-login.jsp" class="active">Organizer Access</a>
                </div>

                <%-- Success/Error Messages from Servlet --%>
                    <% if (request.getAttribute("error") !=null) { %>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <%= request.getAttribute("error") %>
                        </div>
                        <% } %>

                            <form action="OrganizerLoginServlet" method="POST" class="auth-form">
                                <div class="form-group">
                                    <label for="email">Business Email</label>
                                    <div class="input-wrapper">
                                        <input type="email" id="email" name="email" placeholder="official@company.com"
                                            required>
                                        <i class="fas fa-briefcase"></i>
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
                                        <input type="checkbox" name="remember"> Keep me logged in
                                    </label>
                                    <a href="organizer-forgot.jsp" class="forgot-password">Forgot password?</a>
                                </div>

                                <button type="submit" class="btn-auth"
                                    style="background: linear-gradient(135deg, #8b5cf6 0%, #6366f1 100%); border-radius: 12px; box-shadow: 0 8px 25px rgba(139, 92, 246, 0.3);">
                                    Organizer Sign In
                                </button>
                            </form>

                            <div class="auth-footer">
                                Want to list your venue? <a href="organizer-signup.jsp">Register as Organizer</a>
                            </div>
            </div>
        </div>

    </body>

    </html>