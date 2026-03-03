<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.dto.*" %>
<%
    List<Event> events = (List<Event>) request.getAttribute("events");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    Integer selectedCategory = (Integer) request.getAttribute("selectedCategory");
    String selectedCity = (String) request.getAttribute("selectedCity");
    String searchQuery = (String) request.getAttribute("searchQuery");
    
    String categoryName = "";
    if (selectedCategory != null && categories != null) {
        for (Category cat : categories) {
            if (cat.getId() == selectedCategory) {
                categoryName = cat.getName();
                break;
            }
        }
    }
    
    String pageTitle = "All Events";
    String subtitle = "Discover and book amazing events near you";
    
    if (selectedCategory != null && !categoryName.isEmpty()) {
        if (selectedCity != null && !selectedCity.isEmpty()) {
            pageTitle = categoryName + " Events in " + selectedCity;
            subtitle = "Find " + categoryName.toLowerCase() + " events happening in " + selectedCity;
        } else {
            pageTitle = categoryName + " Events";
            subtitle = "Browse all upcoming " + categoryName.toLowerCase() + " events";
        }
    } else if (selectedCity != null && !selectedCity.isEmpty()) {
        pageTitle = "Events in " + selectedCity;
        subtitle = "Discover events happening in " + selectedCity;
    } else if (searchQuery != null && !searchQuery.isEmpty()) {
        pageTitle = "Search Results";
        subtitle = "Events matching: \"" + searchQuery + "\"";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> | EventHub</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/user-style.css">
</head>
<body class="events-page">
    <jsp:include page="../header.jsp" />

    <div class="events-page-wrapper">
        <div class="events-top-section">
            <h1 class="page-title"><%= pageTitle %></h1>
            <p class="page-subtitle"><%= subtitle %></p>
        </div>

        <div class="search-filter-section">
            <div class="search-filter-bar">
                <form action="<%= request.getContextPath() %>/EventServlet" method="get" class="search-filter-form">
                    <input type="hidden" name="action" value="search">
                    
                    <div class="search-box">
                        <span class="search-icon">🔍</span>
                        <input type="text" name="query" placeholder="Search events..." value="<%= searchQuery != null ? searchQuery : "" %>">
                    </div>
                    
                    <div class="filter-dropdown">
                        <select name="categoryId">
                            <option value="">All Categories</option>
                            <% if (categories != null) {
                                for (Category cat : categories) { %>
                            <option value="<%= cat.getId() %>" <%= selectedCategory != null && selectedCategory == cat.getId() ? "selected" : "" %>>
                                <%= cat.getIcon() != null ? cat.getIcon() : "📁" %> <%= cat.getName() %>
                            </option>
                            <% } } %>
                        </select>
                    </div>
                    
                    <div class="filter-dropdown">
                        <select name="city">
                            <option value="">All Cities</option>
                            <option value="Mumbai" <%= "Mumbai".equals(selectedCity) ? "selected" : "" %>>Mumbai</option>
                            <option value="Delhi" <%= "Delhi".equals(selectedCity) ? "selected" : "" %>>Delhi</option>
                            <option value="Bengaluru" <%= "Bengaluru".equals(selectedCity) ? "selected" : "" %>>Bengaluru</option>
                            <option value="Hyderabad" <%= "Hyderabad".equals(selectedCity) ? "selected" : "" %>>Hyderabad</option>
                            <option value="Chennai" <%= "Chennai".equals(selectedCity) ? "selected" : "" %>>Chennai</option>
                            <option value="Pune" <%= "Pune".equals(selectedCity) ? "selected" : "" %>>Pune</option>
                            <option value="Kolkata" <%= "Kolkata".equals(selectedCity) ? "selected" : "" %>>Kolkata</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn-apply-filter">Search</button>
                    <a href="<%= request.getContextPath() %>/EventServlet?action=listEvents" class="btn-clear-filters">Clear</a>
                </form>
            </div>
        </div>

        <div class="events-main-content">
            <% if (events != null && !events.isEmpty()) { %>
            <div class="events-grid">
                <% for (Event event : events) { %>
                <div class="event-card" onclick="window.location.href='<%= request.getContextPath() %>/EventServlet?action=viewEvent&id=<%= event.getId() %>'" style="cursor: pointer;">
                    <div class="event-card-image">
                        <% if (event.getPosterUrl() != null && !event.getPosterUrl().isEmpty()) { %>
                            <img src="<%= event.getPosterUrl() %>" alt="<%= event.getTitle() %>">
                        <% } else { %>
                            <div class="event-image-placeholder">
                                <span><%= event.getCategoryName() != null ? event.getCategoryName() : "🎪" %></span>
                            </div>
                        <% } %>
                    </div>
                    <div class="event-card-body">
                        <h3 class="event-title"><%= event.getTitle() %></h3>
                        <div class="event-info-row">
                            <span class="event-location">📍 <%= event.getLocation() != null ? event.getLocation() : event.getCity() %></span>
                        </div>
                        <div class="event-info-row">
                            <span class="event-date">📅 <%= event.getEventDate() != null ? event.getEventDate().toString() : "TBD" %></span>
                        </div>
                        <div class="event-info-row">
                            <span class="event-seats">💺 <%= event.getAvailableSeats() %> seats available</span>
                        </div>
                        <div class="event-info-row">
                            <span class="event-price">
                                <% if (event.getTicketPrice() != null && event.getTicketPrice().doubleValue() > 0) { %>
                                    ₹<%= event.getTicketPrice().intValue() %>
                                <% } else { %>
                                    Free
                                <% } %>
                            </span>
                        </div>
                        <div class="event-card-footer">
                            <a href="<%= request.getContextPath() %>/EventServlet?action=viewEvent&id=<%= event.getId() %>" class="btn-view-details">View Details</a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <div class="no-events-container">
                <div class="no-events-icon">🎭</div>
                <h2>No events found</h2>
                <p>We couldn't find any events matching your criteria</p>
                <a href="<%= request.getContextPath() %>/EventServlet?action=listEvents" class="btn-view-all-events">Browse All Events</a>
            </div>
            <% } %>
        </div>
    </div>

    <jsp:include page="../footer.jsp" />
</body>
</html>
