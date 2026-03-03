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
    
    Event event = (Event) request.getAttribute("event");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    
    // Check if viewing or editing mode
    String mode = request.getParameter("mode");
    if (mode == null) mode = "view";
    boolean isEditMode = "edit".equals(mode);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Event | EventHub</title>
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
        
        .form-container {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 32px;
            max-width: 800px;
        }
        
        .form-title {
            font-size: 1.5rem;
            color: var(--text-primary);
            margin-bottom: 24px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            color: var(--text-secondary);
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            background: var(--surface);
            border: 1px solid var(--border-color);
            border-radius: 10px;
            color: var(--text-primary);
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.1);
        }
        
        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .btn-submit {
            padding: 14px 32px;
            background: var(--gradient-brand);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(245, 158, 11, 0.3);
        }
        
        .btn-cancel {
            padding: 14px 32px;
            background: transparent;
            color: var(--text-secondary);
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-left: 12px;
            transition: all 0.3s;
        }
        
        .btn-cancel:hover {
            background: var(--surface);
            color: var(--text-primary);
        }
        
        .alert {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.2);
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
                <a href="<%= request.getContextPath() %>/OrganizerServlet?action=dashboard" class="nav-link">
                    <span>📊</span> Dashboard
                </a>
                <a href="<%= request.getContextPath() %>/OrganizerServlet?action=viewMyEvents" class="nav-link active">
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
                <h1>Edit Event</h1>
                <div class="organizer-info">
                    <span>Welcome, <strong><%= organizerName %></strong></span>
                </div>
            </header>

            <%
                String error = request.getParameter("error");
                if (error != null) {
            %>
                <div class="alert alert-danger"><%= error %></div>
            <% 
                }
            %>

            <% if (isEditMode) { %>
            <div class="form-container">
                <h2 class="form-title">Edit Event: <%= event.getTitle() %></h2>
                
                <form action="<%= request.getContextPath() %>/OrganizerServlet" method="post">
                    <input type="hidden" name="action" value="updateEvent">
                    <input type="hidden" name="eventId" value="<%= event.getId() %>">
                    
                    <div class="form-group">
                        <label for="title">Event Title *</label>
                        <input type="text" id="title" name="title" value="<%= event.getTitle() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description *</label>
                        <textarea id="description" name="description" required><%= event.getDescription() %></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="categoryId">Category *</label>
                        <select id="categoryId" name="categoryId" required>
                            <option value="">Select Category</option>
                            <% if (categories != null) {
                                for (Category cat : categories) {
                                    String selected = (cat.getId() == event.getCategoryId()) ? "selected" : "";
                            %>
                                <option value="<%= cat.getId() %>" <%= selected %>><%= cat.getName() %></option>
                            <% 
                                }
                            }
                            %>
                        </select>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="location">Location *</label>
                            <input type="text" id="location" name="location" value="<%= event.getLocation() %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="city">City *</label>
                            <input type="text" id="city" name="city" value="<%= event.getCity() %>" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="venueName">Venue Name *</label>
                        <input type="text" id="venueName" name="venueName" value="<%= event.getVenueName() %>" required>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="eventDate">Event Date *</label>
                            <input type="date" id="eventDate" name="eventDate" value="<%= event.getEventDate() %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="eventTime">Event Time *</label>
                            <input type="time" id="eventTime" name="eventTime" value="<%= event.getEventTime() %>" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="ticketPrice">Ticket Price (₹) *</label>
                            <input type="number" id="ticketPrice" name="ticketPrice" value="<%= event.getTicketPrice() %>" step="0.01" min="0" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="totalSeats">Total Seats *</label>
                            <input type="number" id="totalSeats" name="totalSeats" value="<%= event.getTotalSeats() %>" min="1" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="posterUrl">Poster Image URL</label>
                        <input type="url" id="posterUrl" name="posterUrl" value="<%= event.getPosterUrl() != null ? event.getPosterUrl() : "" %>" placeholder="https://example.com/image.jpg">
                    </div>
                    
                    <button type="submit" class="btn-submit">Update Event</button>
                    <a href="<%= request.getContextPath() %>/OrganizerServlet?action=editEvent&id=<%= event.getId() %>&mode=view" class="btn-cancel">Cancel</a>
                </form>
            </div>
            <% } else { %>
            <div class="form-container">
                <h2 class="form-title"><%= event.getTitle() %></h2>
                
                <div class="form-group">
                    <label>Description</label>
                    <div class="value"><%= event.getDescription() %></div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Category</label>
                        <div class="value"><%= event.getCategoryName() != null ? event.getCategoryName() : "N/A" %></div>
                    </div>
                    
                    <div class="form-group">
                        <label>Status</label>
                        <div class="value"><%= event.getStatus() %></div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Location</label>
                    <div class="value"><%= event.getLocation() %></div>
                </div>
                
                <div class="form-group">
                    <label>City</label>
                    <div class="value"><%= event.getCity() %></div>
                </div>
                
                <div class="form-group">
                    <label>Venue Name</label>
                    <div class="value"><%= event.getVenueName() %></div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Event Date</label>
                        <div class="value"><%= event.getEventDate() %></div>
                    </div>
                    
                    <div class="form-group">
                        <label>Event Time</label>
                        <div class="value"><%= event.getEventTime() %></div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Ticket Price</label>
                        <div class="value"><%= event.getTicketPrice() != null ? "₹" + event.getTicketPrice() : "Free" %></div>
                    </div>
                    
                    <div class="form-group">
                        <label>Available Seats</label>
                        <div class="value"><%= event.getAvailableSeats() %> / <%= event.getTotalSeats() %></div>
                    </div>
                </div>
                
                <div style="margin-top: 24px;">
                    <a href="<%= request.getContextPath() %>/OrganizerServlet?action=editEvent&id=<%= event.getId() %>&mode=edit" class="btn-submit">Edit Event</a>
                    <a href="<%= request.getContextPath() %>/OrganizerServlet?action=viewMyEvents" class="btn-cancel">Back to My Events</a>
                </div>
            </div>
            <% } %>
        </main>
    </div>
</body>
</html>
