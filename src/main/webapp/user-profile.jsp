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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .profile-container {
            max-width: 600px;
            margin: 40px auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 30px;
            text-align: center;
            color: white;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 48px;
            color: #667eea;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .profile-name {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .profile-email {
            font-size: 14px;
            opacity: 0.9;
        }

        .profile-body {
            padding: 30px;
        }

        .profile-info-item {
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }

        .profile-info-item:last-child {
            border-bottom: none;
        }

        .profile-info-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
            margin-right: 15px;
        }

        .profile-info-content {
            flex: 1;
        }

        .profile-info-label {
            font-size: 12px;
            color: #888;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .profile-info-value {
            font-size: 16px;
            color: #333;
            font-weight: 500;
        }

        .profile-actions {
            padding: 0 30px 30px;
            display: flex;
            gap: 15px;
        }

        .btn {
            flex: 1;
            padding: 15px 20px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-outline {
            background: transparent;
            color: #667eea;
            border: 2px solid #667eea;
        }

        .btn-outline:hover {
            background: #667eea;
            color: white;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
            box-shadow: 0 5px 20px rgba(220, 53, 69, 0.4);
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            color: #667eea;
            text-decoration: none;
            padding: 20px 30px;
            font-weight: 600;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="profile-container">
        <%
            // Check if user is logged in
            Integer userId = (Integer) session.getAttribute("userId");
            String userName = (String) session.getAttribute("userName");
            
            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/user-login.jsp");
                return;
            }
            
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="error-message"><%= error %></div>
        <%
            }
        %>
        
        <div class="profile-header">
            <div class="profile-avatar">
                <%= userName != null && !userName.isEmpty() ? userName.charAt(0) : 'U' %>
            </div>
            <h1 class="profile-name"><%= request.getAttribute("userName") != null ? request.getAttribute("userName") : userName %></h1>
            <p class="profile-email"><%= request.getAttribute("userEmail") != null ? request.getAttribute("userEmail") : "" %></p>
        </div>

        <div class="profile-body">
            <div class="profile-info-item">
                <div class="profile-info-icon">👤</div>
                <div class="profile-info-content">
                    <div class="profile-info-label">Full Name</div>
                    <div class="profile-info-value"><%= request.getAttribute("userName") != null ? request.getAttribute("userName") : userName %></div>
                </div>
            </div>

            <div class="profile-info-item">
                <div class="profile-info-icon">📧</div>
                <div class="profile-info-content">
                    <div class="profile-info-label">Email Address</div>
                    <div class="profile-info-value"><%= request.getAttribute("userEmail") != null ? request.getAttribute("userEmail") : "" %></div>
                </div>
            </div>

            <div class="profile-info-item">
                <div class="profile-info-icon">🎫</div>
                <div class="profile-info-content">
                    <div class="profile-info-label">User ID</div>
                    <div class="profile-info-value">#<%= request.getAttribute("userId") != null ? request.getAttribute("userId") : userId %></div>
                </div>
            </div>

            <div class="profile-info-item">
                <div class="profile-info-icon">📅</div>
                <div class="profile-info-content">
                    <div class="profile-info-label">Member Since</div>
                    <div class="profile-info-value">
                        <%
                            Timestamp createdAt = (Timestamp) request.getAttribute("createdAt");
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
            <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">🏠 Back to Home</a>
            <a href="<%= request.getContextPath() %>/ProfileServlet?action=logout" class="btn btn-danger">🚪 Logout</a>
        </div>
    </div>

</body>
</html>
