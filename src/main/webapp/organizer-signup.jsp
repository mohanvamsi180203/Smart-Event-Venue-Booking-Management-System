<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Organizer Signup | EventHub</title>

    <!-- CSS -->
    <link rel="stylesheet" href="css/user-style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        .alert {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 15px;
            font-size: 14px;
        }
        .alert-error {
            background-color: #ffe5e5;
            color: #d8000c;
        }
        .alert-success {
            background-color: #e6ffed;
            color: #1b7e3c;
        }
    </style>
</head>

<body>

<div class="auth-wrapper">
    <div class="auth-card">

        <!-- Header -->
        <div class="auth-header">
            <a href="index.jsp" class="logo">EventHub</a>
            <h2>Organizer Signup</h2>
            <p>Start managing your events and venues with ease</p>
        </div>

        <!-- Toggle -->
        <div class="auth-toggle">
            <a href="user-signup.jsp">User Signup</a>
            <a href="organizer-signup.jsp" class="active">Organizer Signup</a>
        </div>

        <!-- Error Message from Servlet -->
        <%
            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
        %>

        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <%= error %>
            </div>
        <% } %>

        <% if (success != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= success %>
            </div>
        <% } %>

        <!-- Organizer Signup Form (MVC → Controller) -->
        <form action="OrganizerSignupServlet" method="POST" class="auth-form">

            <!-- Organization Name -->
            <div class="form-group">
                <label for="org-name">Organization Name</label>
                <div class="input-wrapper">
                    <input 
                        type="text" 
                        id="org-name" 
                        name="org-name"
                        placeholder="Event Solutions Pvt Ltd"
                        required 
                        maxlength="100">
                    <i class="fas fa-building"></i>
                </div>
            </div>

            <!-- Business Email -->
            <div class="form-group">
                <label for="email">Business Email</label>
                <div class="input-wrapper">
                    <input 
                        type="email" 
                        id="email" 
                        name="email"
                        placeholder="official@company.com"
                        required>
                    <i class="fas fa-envelope"></i>
                </div>
            </div>

            <!-- Mobile Number -->
            <div class="form-group">
                <label for="mobile">Mobile Number</label>
                <div class="input-wrapper">
                    <input 
                        type="tel" 
                        id="mobile" 
                        name="mobile"
                        placeholder="+91 9876543210"
                        pattern="[0-9]{10,15}"
                        title="Enter valid mobile number"
                        required>
                    <i class="fas fa-phone"></i>
                </div>
            </div>

            <!-- Password -->
            <div class="form-group">
                <label for="password">Password</label>
                <div class="input-wrapper">
                    <input 
                        type="password" 
                        id="password" 
                        name="password"
                        placeholder="Minimum 8 characters"
                        minlength="8"
                        required>
                    <i class="fas fa-lock"></i>
                </div>
            </div>

            <!-- Confirm Password -->
            <div class="form-group">
                <label for="confirm-password">Confirm Password</label>
                <div class="input-wrapper">
                    <input 
                        type="password" 
                        id="confirm-password" 
                        name="confirm-password"
                        placeholder="Re-enter password"
                        minlength="8"
                        required>
                    <i class="fas fa-shield-alt"></i>
                </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn-auth"
                    style="background: linear-gradient(135deg, #8b5cf6 0%, #6366f1 100%);">
                <i class="fas fa-user-plus"></i> Register Organizer
            </button>

        </form>

        <!-- Footer -->
        <div class="auth-footer">
            Already registered?
            <a href="organizer-login.jsp">Organizer Login</a>
        </div>

    </div>
</div>

</body>
</html>