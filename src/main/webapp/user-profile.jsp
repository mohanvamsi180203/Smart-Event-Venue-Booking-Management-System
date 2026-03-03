<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Check if user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/user-login.jsp");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | EventHub</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: var(--bg-dark);
            padding-top: 80px;
        }
        
        .profile-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 40px 24px;
        }
        
        .profile-card {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 40px;
        }
        
        .profile-header {
            text-align: center;
            margin-bottom: 32px;
        }
        
        .profile-header .logo {
            font-family: 'Outfit', sans-serif;
            font-size: 24px;
            font-weight: 800;
            background: var(--gradient-brand);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: block;
            margin-bottom: 8px;
            text-decoration: none;
        }
        
        .profile-header h2 {
            font-size: 24px;
            color: var(--text-primary);
            margin-bottom: 8px;
        }
        
        .profile-header p {
            color: var(--text-secondary);
            font-size: 14px;
        }
        
        .profile-info {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        
        .profile-item {
            display: flex;
            align-items: center;
            padding: 16px;
            background: var(--surface);
            border: 1px solid var(--border-color);
            border-radius: 12px;
        }
        
        .profile-item i {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(245, 158, 11, 0.1);
            border-radius: 10px;
            color: var(--brand-primary);
            font-size: 18px;
            margin-right: 16px;
        }
        
        .profile-item .item-content {
            flex: 1;
        }
        
        .profile-item .item-label {
            font-size: 12px;
            color: var(--text-muted);
            margin-bottom: 4px;
        }
        
        .profile-item .item-value {
            font-size: 15px;
            color: var(--text-primary);
            font-weight: 500;
        }
        
        .profile-actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
        }
        
        .btn-profile {
            flex: 1;
            padding: 14px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            text-decoration: none;
        }
        
        .btn-profile-primary {
            background: var(--gradient-brand);
            color: white;
            border: none;
        }
        
        .btn-profile-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(245, 158, 11, 0.3);
        }
        
        .btn-profile-secondary {
            background: var(--surface);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }
        
        .btn-profile-secondary:hover {
            background: var(--bg-card-hover);
            border-color: var(--brand-primary);
        }
        
        .alert {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .alert-error {
            background: rgba(239, 68, 68, 0.1);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }
        
        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }
    </style>
</head>

<body>

    <jsp:include page="header.jsp" />

    <div class="profile-container">
        <div class="profile-card">
            <div class="profile-header">
                <a href="<%= request.getContextPath() %>/index.jsp" class="logo">EventHub</a>
                <h2>My Profile</h2>
                <p>View your account information</p>
            </div>

            <%-- Error/Success Messages --%>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>

            <div class="profile-info">
                <div class="profile-item">
                    <i class="fas fa-user"></i>
                    <div class="item-content">
                        <div class="item-label">Full Name</div>
                        <div class="item-value"><%= userName != null ? userName : "N/A" %></div>
                    </div>
                </div>

                <div class="profile-item">
                    <i class="fas fa-envelope"></i>
                    <div class="item-content">
                        <div class="item-label">Email Address</div>
                        <div class="item-value"><%= userEmail != null ? userEmail : "N/A" %></div>
                    </div>
                </div>

                <div class="profile-item">
                    <i class="fas fa-id-badge"></i>
                    <div class="item-content">
                        <div class="item-label">User ID</div>
                        <div class="item-value">#<%= userId != null ? userId : "N/A" %></div>
                    </div>
                </div>
            </div>

            <div class="profile-actions">
                <a href="<%= request.getContextPath() %>/index.jsp" class="btn-profile btn-profile-secondary">
                    <i class="fas fa-home"></i> Back to Home
                </a>
                <a href="<%= request.getContextPath() %>/UserServlet?action=logout" class="btn-profile btn-profile-primary">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>

</body>

</html>
