<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | EventHub</title>
    <link rel="stylesheet" href="css/user-style.css">
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .profile-info {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        
        .profile-item {
            display: flex;
            align-items: center;
            padding: 16px;
            background: rgba(255, 255, 255, 0.04);
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
            transition: all var(--transition-smooth);
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
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }
        
        .btn-profile-secondary:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: var(--brand-primary);
        }
    </style>
</head>

<body>

    <div class="auth-wrapper">
        <div class="auth-card">
            <div class="auth-header">
                <a href="index.jsp" class="logo">EventHub</a>
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
                        <div class="item-value"><%= request.getAttribute("userName") != null ? request.getAttribute("userName") : "N/A" %></div>
                    </div>
                </div>

                <div class="profile-item">
                    <i class="fas fa-envelope"></i>
                    <div class="item-content">
                        <div class="item-label">Email Address</div>
                        <div class="item-value"><%= request.getAttribute("userEmail") != null ? request.getAttribute("userEmail") : "N/A" %></div>
                    </div>
                </div>

                <div class="profile-item">
                    <i class="fas fa-id-badge"></i>
                    <div class="item-content">
                        <div class="item-label">User ID</div>
                        <div class="item-value">#<%= request.getAttribute("userId") != null ? request.getAttribute("userId") : "N/A" %></div>
                    </div>
                </div>

                <div class="profile-item">
                    <i class="fas fa-calendar-alt"></i>
                    <div class="item-content">
                        <div class="item-label">Member Since</div>
                        <div class="item-value">
                            <% 
                                Object createdAt = request.getAttribute("createdAt");
                                if (createdAt != null) {
                                    SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy");
                                    out.print(sdf.format(createdAt));
                                } else {
                                    out.print("N/A");
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>

            <div class="profile-actions">
                <a href="index.jsp" class="btn-profile btn-profile-secondary">
                    <i class="fas fa-home"></i> Back to Home
                </a>
                <a href="<%= request.getContextPath() %>/ProfileServlet?action=logout" class="btn-profile btn-profile-primary">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>

</body>

</html>
