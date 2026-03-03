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
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories | EventHub Admin</title>
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
                <a href="<%= request.getContextPath() %>/AdminServlet?action=viewCategories" class="nav-link active">
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
                <h1>Manage Categories</h1>
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

            <!-- Add Category Form -->
            <div class="form-card" style="margin-bottom: 20px;">
                <h3>Add New Category</h3>
                <form action="<%= request.getContextPath() %>/AdminServlet" method="post">
                    <input type="hidden" name="action" value="addCategory">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="name">Category Name</label>
                            <input type="text" id="name" name="name" required placeholder="e.g., Sports">
                        </div>
                        <div class="form-group">
                            <label for="icon">Icon (Emoji)</label>
                            <input type="text" id="icon" name="icon" placeholder="e.g., 🏟️">
                        </div>
                        <div class="form-group">
                            <label for="description">Description</label>
                            <input type="text" id="description" name="description" placeholder="Category description">
                        </div>
                        <div class="form-group" style="display: flex; align-items: flex-end;">
                            <button type="submit" class="btn-action btn-approve">Add Category</button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Categories Table -->
            <div class="data-table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Icon</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (categories != null && !categories.isEmpty()) {
                            for (Category cat : categories) { %>
                        <tr>
                            <td><%= cat.getId() %></td>
                            <td><%= cat.getIcon() != null ? cat.getIcon() : "🏷️" %></td>
                            <td><%= cat.getName() %></td>
                            <td><%= cat.getDescription() != null ? cat.getDescription() : "-" %></td>
                            <td>
                                <span class="status-badge <%= cat.isActive() ? "approved" : "rejected" %>">
                                    <%= cat.isActive() ? "ACTIVE" : "INACTIVE" %>
                                </span>
                            </td>
                            <td>
                                <form action="<%= request.getContextPath() %>/AdminServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="deleteCategory">
                                    <input type="hidden" name="id" value="<%= cat.getId() %>">
                                    <button type="submit" class="btn-action btn-reject" onclick="return confirm('Are you sure?')">Delete</button>
                                </form>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="6" class="text-center">No categories found</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>
