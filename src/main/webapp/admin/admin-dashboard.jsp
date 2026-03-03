<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.dto.*" %>
<%
    // Check if admin is logged in
    Integer adminId = (Integer) session.getAttribute("adminId");
    if (adminId == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }
    String adminName = (String) session.getAttribute("adminUsername");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | EventHub</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin-style.css">
</head>
<body class="admin-dashboard-body">
    <div class="admin-wrapper">
        <!-- Sidebar -->
        <aside class="admin-sidebar">
            <div class="sidebar-header">
                <h2>EventHub</h2>
                <span class="admin-label">Admin Panel</span>
            </div>
            <nav class="sidebar-nav">
                <a href="<%= request.getContextPath() %>/AdminServlet?action=dashboard" class="nav-link active">
                    <span>📊</span> Dashboard
                </a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewOrganizers" class="nav-link">
                    <span>👥</span> Organizers
                </a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewEvents" class="nav-link">
                    <span>🎪</span> Events
                </a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewCategories" class="nav-link">
                    <span>🏷️</span> Categories
                </a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewBookings" class="nav-link">
                    <span>🎟️</span> Bookings
                </a>
            </nav>
            <div class="sidebar-footer">
                <a href="<%= request.getContextPath() %>/AdminServlet?action=logout" class="nav-link logout">
                    <span>🚪</span> Logout
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="admin-main">
            <header class="admin-header">
                <h1>Dashboard</h1>
                <div class="admin-user">
                    <span>Welcome, <strong><%= adminName %></strong></span>
                </div>
            </header>

            <%
                String success = request.getParameter("success");
                String error = request.getParameter("error");
                if (success != null) {
            %>
                <div class="alert alert-success"><%= success %></div>
            <% 
                }
                if (error != null) {
            %>
                <div class="alert alert-danger"><%= error %></div>
            <% 
                }
            %>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">🎪</div>
                    <div class="stat-info">
                        <h3><%= request.getAttribute("totalEvents") != null ? request.getAttribute("totalEvents") : 0 %></h3>
                        <p>Total Events</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">✅</div>
                    <div class="stat-info">
                        <h3><%= request.getAttribute("approvedEvents") != null ? request.getAttribute("approvedEvents") : 0 %></h3>
                        <p>Approved Events</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">⏳</div>
                    <div class="stat-info">
                        <h3><%= request.getAttribute("pendingEvents") != null ? request.getAttribute("pendingEvents") : 0 %></h3>
                        <p>Pending Events</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-info">
                        <h3><%= request.getAttribute("approvedOrganizers") != null ? request.getAttribute("approvedOrganizers") : 0 %></h3>
                        <p>Active Organizers</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">📝</div>
                    <div class="stat-info">
                        <h3><%= request.getAttribute("pendingOrganizers") != null ? request.getAttribute("pendingOrganizers") : 0 %></h3>
                        <p>Pending Organizers</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🎫</div>
                    <div class="stat-info">
                        <h3><%= request.getAttribute("totalBookings") != null ? request.getAttribute("totalBookings") : 0 %></h3>
                        <p>Total Bookings</p>
                    </div>
                </div>
                <div class="stat-card revenue">
                    <div class="stat-icon">💰</div>
                    <div class="stat-info">
                        <h3>₹<%= String.format("%.2f", request.getAttribute("totalRevenue") != null ? request.getAttribute("totalRevenue") : 0.0) %></h3>
                        <p>Total Revenue</p>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <h2>Quick Actions</h2>
                <div class="actions-grid">
                    <a href="<%= request.getContextPath() %>/AdminServlet?action=viewOrganizers&status=pending" class="action-card">
                        <span>👥</span>
                        <div>
                            <h4>Review Organizers</h4>
                            <p><%= request.getAttribute("pendingOrganizers") != null ? request.getAttribute("pendingOrganizers") : 0 %> pending requests</p>
                        </div>
                    </a>
                    <a href="<%= request.getContextPath() %>/AdminServlet?action=viewEvents" class="action-card">
                        <span>🎪</span>
                        <div>
                            <h4>Manage Events</h4>
                            <p>View all events</p>
                        </div>
                    </a>
                    <a href="<%= request.getContextPath() %>/AdminServlet?action=viewCategories" class="action-card">
                        <span>🏷️</span>
                        <div>
                            <h4>Categories</h4>
                            <p>Manage event categories</p>
                        </div>
                    </a>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
