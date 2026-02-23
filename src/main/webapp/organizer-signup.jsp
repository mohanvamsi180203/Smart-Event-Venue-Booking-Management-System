<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Organizer Registration | EventHub</title>
        <link rel="stylesheet" href="css/user-style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>

    <body>

        <div class="auth-wrapper">
            <div class="auth-card">
                <div class="auth-header">
                    <a href="index.jsp" class="logo">EventHub</a>
                    <h2>Organizer Signup</h2>
                    <p>Start managing your events and venues with ease</p>
                </div>

                <div class="auth-toggle">
                    <a href="user-signup.jsp">User Signup</a>
                    <a href="organizer-signup.jsp" class="active">Organizer Signup</a>
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

                                    <form action="OrganizerSignupServlet" method="POST" class="auth-form">
                                        <div class="form-group">
                                            <label for="org-name">Organization Name</label>
                                            <div class="input-wrapper">
                                                <input type="text" id="org-name" name="org-name"
                                                    placeholder="Event Solutions Ltd" required>
                                                <i class="fas fa-building"></i>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label for="email">Business Email</label>
                                            <div class="input-wrapper">
                                                <input type="email" id="email" name="email"
                                                    placeholder="official@company.com" required>
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
                                            <label for="confirm-password">Confirm Password</label>
                                            <div class="input-wrapper">
                                                <input type="password" id="confirm-password" name="confirm-password"
                                                    placeholder="••••••••" required>
                                                <i class="fas fa-shield-alt"></i>
                                            </div>
                                        </div>

                                        <button type="submit" class="btn-auth"
                                            style="background: linear-gradient(135deg, #8b5cf6 0%, #6366f1 100%);">
                                            Register Organizer
                                        </button>
                                    </form>

                                    <div class="auth-footer">
                                        Already registered? <a href="organizer-login.jsp">Organizer Login</a>
                                    </div>
            </div>
        </div>

    </body>

    </html>