<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.dto.*" %>
<%
    // Check if organizer is logged in
    Integer organizerId = (Integer) session.getAttribute("organizerId");
    if (organizerId == null) {
        response.sendRedirect(request.getContextPath() + "/organizer-login.jsp");
        return;
    }
    String organizerName = (String) session.getAttribute("organizerName");
    
    List<Event> events = (List<Event>) request.getAttribute("events");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Organizer Dashboard | EventHub</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <style>
        body {
            background: var(--bg-dark);
        }
        
        .dashboard-wrapper {
            display: flex;
            min-height: 100vh;
        }
        
        .dashboard-sidebar {
            width: 260px;
            background: var(--bg-card);
            border-right: 1px solid var(--border-color);
            padding: 24px 0;
            position: fixed;
            height: 100vh;
            left: 0;
            top: 0;
        }
        
        .sidebar-header {
            padding: 0 24px 24px;
            border-bottom: 1px solid var(--border-color);
        }
        
        .sidebar-header h2 {
            font-size: 1.5rem;
            background: var(--gradient-brand);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .organizer-label {
            color: var(--text-muted);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .sidebar-nav {
            padding: 16px 0;
        }
        
        .nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 24px;
            color: var(--text-secondary);
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .nav-link:hover, .nav-link.active {
            background: rgba(245, 158, 11, 0.1);
            color: var(--brand-primary);
            border-left: 3px solid var(--brand-primary);
        }
        
        .nav-link.logout {
            border-top: 1px solid var(--border-color);
            margin-top: auto;
            color: #ef4444;
        }
        
        .sidebar-footer {
            padding: 16px 0;
            border-top: 1px solid var(--border-color);
            position: absolute;
            bottom: 0;
            width: 100%;
        }
        
        .dashboard-main {
            flex: 1;
            margin-left: 260px;
            padding: 32px;
        }
        
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
        }
        
        .dashboard-header h1 {
            font-size: 1.75rem;
            color: var(--text-primary);
        }
        
        .organizer-info {
            color: var(--text-secondary);
        }
        
        .organizer-info strong {
            color: var(--text-primary);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 24px;
            display: flex;
            align-items: center;
            gap: 16px;
            transition: all 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-4px);
            border-color: var(--brand-primary);
        }
        
        .stat-icon {
            width: 56px;
            height: 56px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            background: rgba(245, 158, 11, 0.1);
        }
        
        .stat-card:nth-child(2) .stat-icon { background: rgba(16, 185, 129, 0.1); }
        .stat-card:nth-child(3) .stat-icon { background: rgba(139, 92, 246, 0.1); }
        
        .stat-info h3 {
            font-size: 1.75rem;
            color: var(--text-primary);
            margin-bottom: 4px;
        }
        
        .stat-info p {
            color: var(--text-muted);
            font-size: 0.875rem;
        }
        
        .events-section {
            margin-bottom: 40px;
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .section-header h2 {
            font-size: 1.25rem;
            color: var(--text-primary);
        }
        
        .btn-add-event {
            padding: 10px 20px;
            background: var(--gradient-brand);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .btn-add-event:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(245, 158, 11, 0.3);
        }
        
        .events-table {
            width: 100%;
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            overflow: hidden;
        }
        
        .events-table th,
        .events-table td {
            padding: 16px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }
        
        .events-table th {
            background: var(--surface);
            font-weight: 600;
            color: var(--text-secondary);
            font-size: 0.875rem;
        }
        
        .events-table tr:last-child td {
            border-bottom: none;
        }
        
        .events-table tr:hover {
            background: rgba(245, 158, 11, 0.02);
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .status-badge.pending {
            background: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
        }
        
        .status-badge.approved {
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
        }
        
        .status-badge.rejected {
            background: rgba(239, 68, 68, 0.1);
            color: #ef4444;
        }
        
        .action-btns {
            display: flex;
            gap: 8px;
        }
        
        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.875rem;
            text-decoration: none;
        }
        
        .btn-view {
            background: rgba(139, 92, 246, 0.1);
            color: #8b5cf6;
        }
        
        .btn-edit {
            background: rgba(59, 130, 246, 0.1);
            color: #3b82f6;
        }
        
        .btn-delete {
            background: rgba(239, 68, 68, 0.1);
            color: #ef4444;
        }
        
        .alert {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }
        
        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }
        
        .no-events {
            text-align: center;
            padding: 40px;
            color: var(--text-muted);
        }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <!-- Sidebar -->
        <aside class="dashboard-sidebar">
            <div class="sidebar-header">
                <h2>EventHub</h2>
                <span class="organizer-label">Organizer Panel</span>
            </div>
            <nav class="sidebar-nav">
                <a href="<%= request.getContextPath() %>/OrganizerServlet?action=dashboard" class="nav-link active">
                    <span>📊</span> Dashboard
                </a>
                <a href="<%= request.getContextPath() %>/OrganizerServlet?action=viewMyEvents" class="nav-link">
                    <span>🎪</span> My Events
                </a>
            </nav>
            <div class="sidebar-footer">
                <a href="<%= request.getContextPath() %>/OrganizerServlet?action=logout" class="nav-link logout">
                    <span>🚪</span> Logout
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="dashboard-main">
            <header class="dashboard-header">
                <h1>Dashboard</h1>
                <div class="organizer-info">
                    <span>Welcome, <strong><%= organizerName %></strong></span>
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
            </div>

            <!-- Events Table -->
            <div class="events-section">
                <div class="section-header">
                    <h2>My Events</h2>
                    <a href="<%= request.getContextPath() %>/OrganizerServlet?action=addEvent" class="btn-add-event">+ Add Event</a>
                </div>
                
                <% if (events != null && !events.isEmpty()) { %>
                <table class="events-table">
                    <thead>
                        <tr>
                            <th>Event Name</th>
                            <th>Date</th>
                            <th>City</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Event event : events) { %>
                        <tr>
                            <td><%= event.getTitle() %></td>
                            <td><%= event.getEventDate() %></td>
                            <td><%= event.getCity() %></td>
                            <td><%= event.getTicketPrice() != null ? "₹" + event.getTicketPrice() : "Free" %></td>
                            <td><span class="status-badge <%= event.getStatus() %>"><%= event.getStatus() %></span></td>
                            <td>
                                <div class="action-btns">
                                    <a href="<%= request.getContextPath() %>/OrganizerServlet?action=editEvent&id=<%= event.getId() %>" class="btn-action btn-view">View/Edit</a>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <div class="no-events">
                    <p>No events yet. Create your first event!</p>
                </div>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>
