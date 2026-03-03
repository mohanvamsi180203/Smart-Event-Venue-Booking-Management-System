<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.dto.*" %>
<%
    // Check if admin is logged in
    Integer adminId = (Integer) session.getAttribute("adminId");
    if (adminId == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }
    String adminName = (String) session.getAttribute("adminUsername");
    List<Organizer> organizers = (List<Organizer>) request.getAttribute("organizers");
    String status = (String) request.getAttribute("status");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Organizers | EventHub Admin</title>
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
                <a href="<%= request.getContextPath() %>/AdminServlet?action=dashboard" class="nav-link">
                    <span>📊</span> Dashboard
                </a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewOrganizers" class="nav-link active">
                    <span>👥</span> Organizers
                </a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewEvents" class="nav-link">
                    <span>🎪</span> Events
                </a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewCategories" class="nav-link">
                    <span>📁</span> Categories
                </a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewBookings" class="nav-link">
                    <span>🎫</span> Bookings
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
                <h1>Manage Organizers</h1>
                <div class="admin-user">
                    <span>Welcome, <%= adminName %></span>
                </div>
            </header>

            <!-- Messages -->
            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success"><%= request.getParameter("success") %></div>
            <% } %>
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger"><%= request.getParameter("error") %></div>
            <% } %>

            <!-- Filter -->
            <div class="admin-filters">
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewOrganizers" class="filter-btn <%= status == null ? "active" : "" %>">All</a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewOrganizers&status=pending" class="filter-btn <%= "pending".equals(status) ? "active" : "" %>">Pending</a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewOrganizers&status=approved" class="filter-btn <%= "approved".equals(status) ? "active" : "" %>">Approved</a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewOrganizers&status=rejected" class="filter-btn <%= "rejected".equals(status) ? "active" : "" %>">Rejected</a>
            </div>

            <!-- Organizers Table -->
            <div class="data-table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Company</th>
                            <th>Phone</th>
                            <th>Status</th>
                            <th>Joined Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (organizers != null && !organizers.isEmpty()) {
                            for (Organizer org : organizers) { %>
                        <tr>
                            <td><%= org.getId() %></td>
                            <td><%= org.getName() %></td>
                            <td><%= org.getEmail() %></td>
                            <td><%= org.getCompanyName() != null ? org.getCompanyName() : "-" %></td>
                            <td><%= org.getPhone() != null ? org.getPhone() : "-" %></td>
                            <td>
                                <span class="status-badge <%= org.getStatus() %>">
                                    <%= org.getStatus() != null ? org.getStatus().toUpperCase() : "PENDING" %>
                                </span>
                            </td>
                            <td><%= org.getCreatedAt() != null ? org.getCreatedAt().toString().substring(0, 10) : "-" %></td>
                            <td>
                                <% if ("pending".equals(org.getStatus())) { %>
                                    <a href="<%= request.getContextPath() %>/AdminServlet?action=approveOrganizer&id=<%= org.getId() %>" class="btn-action btn-approve">Approve</a>
                                    <a href="<%= request.getContextPath() %>/AdminServlet?action=rejectOrganizer&id=<%= org.getId() %>" class="btn-action btn-reject">Reject</a>
                                <% } else { %>
                                    <span class="text-muted">-</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="8" class="text-center">No organizers found</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>
