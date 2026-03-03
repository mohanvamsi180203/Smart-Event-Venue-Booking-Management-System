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
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bookings | EventHub Admin</title>
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
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewEvents" class="nav-link">
                    <span>🎪</span> Events
                </a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewCategories" class="nav-link">
                    <span>📁</span> Categories
                </a>
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewBookings" class="nav-link active">
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
                <h1>Manage Bookings</h1>
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

            <!-- Bookings Table -->
            <div class="data-table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Reference</th>
                            <th>User ID</th>
                            <th>Event ID</th>
                            <th>Tickets</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Booking Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (bookings != null && !bookings.isEmpty()) {
                            for (Booking booking : bookings) { %>
                        <tr>
                            <td><%= booking.getId() %></td>
                            <td><%= booking.getBookingReference() %></td>
                            <td><%= booking.getUserId() %></td>
                            <td><%= booking.getEventId() %></td>
                            <td><%= booking.getNumberOfTickets() %></td>
                            <td>₹<%= booking.getTotalAmount() %></td>
                            <td>
                                <span class="status-badge <%= booking.getBookingStatus() %>">
                                    <%= booking.getBookingStatus() != null ? booking.getBookingStatus().toUpperCase() : "PENDING" %>
                                </span>
                            </td>
                            <td><%= booking.getBookingDate() != null ? booking.getBookingDate().toString().substring(0, 19) : "-" %></td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="8" class="text-center">No bookings found</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>
