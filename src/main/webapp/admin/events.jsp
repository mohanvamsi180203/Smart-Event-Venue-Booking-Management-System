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
    List<Event> events = (List<Event>) request.getAttribute("events");
    String status = (String) request.getAttribute("status");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Events | EventHub Admin</title>
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
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewOrganizers" class="nav-link">
                    <span>👥</span> Organizers
                </a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewEvents" class="nav-link active">
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
                <h1>Manage Events</h1>
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
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewEvents" class="filter-btn <%= status == null ? "active" : "" %>">All</a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewEvents&status=pending" class="filter-btn <%= "pending".equals(status) ? "active" : "" %>">Pending</a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewEvents&status=approved" class="filter-btn <%= "approved".equals(status) ? "active" : "" %>">Approved</a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewEvents&status=rejected" class="filter-btn <%= "rejected".equals(status) ? "active" : "" %>">Rejected</a>
            </div>

            <!-- Events Table -->
            <div class="data-table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Organizer</th>
                            <th>City</th>
                            <th>Date</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (events != null && !events.isEmpty()) {
                            for (Event event : events) { %>
                        <tr>
                            <td><%= event.getId() %></td>
                            <td><%= event.getTitle() %></td>
                            <td><%= event.getCategoryName() != null ? event.getCategoryName() : "-" %></td>
                            <td><%= event.getOrganizerName() != null ? event.getOrganizerName() : "-" %></td>
                            <td><%= event.getCity() %></td>
                            <td><%= event.getEventDate() != null ? event.getEventDate().toString() : "-" %></td>
                            <td>₹<%= event.getTicketPrice() %></td>
                            <td>
                                <span class="status-badge <%= event.getStatus() %>">
                                    <%= event.getStatus() != null ? event.getStatus().toUpperCase() : "PENDING" %>
                                </span>
                            </td>
                            <td>
                                <% if ("pending".equals(event.getStatus())) { %>
                                    <a href="<%= request.getContextPath() %>/AdminServlet?action=approveEvent&id=<%= event.getId() %>" class="btn-action btn-approve">Approve</a>
                                    <a href="<%= request.getContextPath() %>/AdminServlet?action=rejectEvent&id=<%= event.getId() %>" class="btn-action btn-reject">Reject</a>
                                <% } else { %>
                                    <span class="text-muted">-</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="9" class="text-center">No events found</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>
