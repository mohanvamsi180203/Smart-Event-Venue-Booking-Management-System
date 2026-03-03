<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.dto.*, com.dao.*" %>
<%
    // Load categories for the filter
    CategoryDao categoryDao = new CategoryDao();
    List<Category> categories = categoryDao.getActiveCategories();
    
    // Load cities for location filter
    EventDao eventDao = new EventDao();
    List<String> cities = eventDao.getUniqueCities();
    
    // Get filter parameters
    String selectedCity = request.getParameter("city");
    Integer selectedCategoryId = null;
    if (request.getParameter("categoryId") != null && !request.getParameter("categoryId").isEmpty()) {
        selectedCategoryId = Integer.parseInt(request.getParameter("categoryId"));
    }
    
    // Load events based on filters
    List<Event> events;
    if (selectedCategoryId != null && selectedCity != null && !selectedCity.isEmpty()) {
        events = eventDao.getEventsByCategoryAndCity(selectedCategoryId, selectedCity);
    } else if (selectedCategoryId != null) {
        events = eventDao.getEventsByCategory(selectedCategoryId);
    } else if (selectedCity != null && !selectedCity.isEmpty()) {
        events = eventDao.getEventsByCity(selectedCity);
    } else {
        events = eventDao.getApprovedEvents();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description"
        content="EventHub - Your premier multi-event booking platform. Discover and book concerts, sports, conferences, and more at premium venues.">
    <title>EventHub | Discover and Book Amazing Events</title>

    <link rel="stylesheet" href="css/styles.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
</head>

<body>

    <!-- NAVBAR -->
    <header class="navbar" id="navbar">
        <div class="nav-left">
            <a href="<%= request.getContextPath() %>/index.jsp" class="logo">EventHub</a>
            
            <!-- Location Dropdown -->
            <div class="location-dropdown">
                <select id="location-select" onchange="filterByLocation(this.value)">
                    <option value="">All Cities</option>
                    <% if (cities != null) {
                        for (String city : cities) { %>
                    <option value="<%= city %>" <%= city.equals(selectedCity) ? "selected" : "" %>><%= city %></option>
                    <% } } %>
                </select>
            </div>
        </div>

        <div class="nav-center">
            <a href="<%= request.getContextPath() %>/EventServlet?action=listEvents" class="nav-link">Browse All Events</a>
        </div>

        <div class="nav-right">
            <% Integer loggedInUserIdNav = (Integer) session.getAttribute("userId"); 
               if (loggedInUserIdNav != null) { %>
                <a href="<%= request.getContextPath() %>/EventServlet?action=myBookings" class="btn-outline" id="nav-tickets">My Tickets</a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/user-login.jsp" class="btn-outline" id="nav-tickets">My Tickets</a>
            <% } %>
            
            <%
                Integer loggedInUserId = (Integer) session.getAttribute("userId");
                String loggedInUserName = (String) session.getAttribute("userName");
                
                if (loggedInUserId != null) {
            %>
                <div class="user-profile-dropdown">
                    <button class="profile-btn" id="nav-profile" onclick="toggleDropdown()">
                        <span class="profile-avatar-small">U</span>
                        <span class="profile-name-small"><%= loggedInUserName %></span>
                        <span class="dropdown-arrow">v</span>
                    </button>
                    <div class="dropdown-menu" id="dropdown-menu">
                        <a href="<%= request.getContextPath() %>/ProfileServlet" class="dropdown-item">My Profile</a>
                        <a href="<%= request.getContextPath() %>/EventServlet?action=myBookings" class="dropdown-item">My Bookings</a>
                        <div class="dropdown-divider"></div>
                        <a href="<%= request.getContextPath() %>/UserServlet?action=logout" class="dropdown-item logout">Logout</a>
                    </div>
                </div>
            <%
                } else {
            %>
                <a href="<%= request.getContextPath() %>/user-login.jsp" id="nav-login">Login</a>
                <a href="<%= request.getContextPath() %>/user-signup.jsp" class="btn-primary" id="nav-signup">Sign Up</a>
            <%
                }
            %>
        </div>
    </header>

    <!-- HERO SECTION -->
    <section class="hero" id="hero">
        <div class="hero-slider">
            <img class="slide active" src="images/concert.jpg" alt="Live Concert Event">
            <img class="slide" src="images/conference.jpg" alt="Professional Conference">
            <img class="slide" src="images/turf.jpg" alt="Sports Turf Venue">
        </div>
        <div class="hero-overlay"></div>

        <div class="hero-content">
            <div class="hero-badge">
                <span class="pulse-dot"></span>
                Live Events Near You
            </div>

            <h2 class="hero-title">
                Discover <span class="gradient-text">Extraordinary</span> Events and Venues
            </h2>

            <p class="hero-description">
                Find and book the perfect venue for concerts, conferences, sports, and celebrations.
            </p>

            <div class="hero-actions">
                <a href="#featured-events" class="btn btn-hero-primary" id="btn-explore">
                    Explore Events
                </a>
            </div>
        </div>
    </section>

    <!-- CATEGORIES -->
    <section class="categories" id="categories">
        <a href="<%= request.getContextPath() %>/EventServlet?action=listEvents" class="category reveal" id="cat-all">
            <span class="cat-icon">E</span>
            <span class="cat-label">All Events</span>
        </a>
        <% if (categories != null) {
            int delay = 0;
            for (Category cat : categories) { %>
        <a href="<%= request.getContextPath() %>/EventServlet?action=filterByCategory&categoryId=<%= cat.getId() %>" 
           class="category reveal" 
           id="cat-<%= cat.getId() %>">
            <span class="cat-icon"><%= cat.getIcon() != null ? cat.getIcon() : "E" %></span>
            <span class="cat-label"><%= cat.getName() %></span>
        </a>
        <% } } else { %>
        <div class="category reveal" id="cat-concerts">
            <span class="cat-icon">C</span>
            <span class="cat-label">Concerts</span>
        </div>
        <div class="category reveal" id="cat-sports">
            <span class="cat-icon">S</span>
            <span class="cat-label">Sports</span>
        </div>
        <div class="category reveal" id="cat-movies">
            <span class="cat-icon">M</span>
            <span class="cat-label">Movies</span>
        </div>
        <% } %>
    </section>

    <!-- FEATURED EVENTS -->
    <section class="featured-events" id="featured-events">
        <div class="container">
            <div class="section-header reveal">
                <span class="section-badge">Trending Now</span>
                <h2 class="section-title">Featured Events</h2>
            </div>

            <div class="events-grid">
                <% if (events != null && !events.isEmpty()) {
                    for (Event event : events) { %>
                <div class="event-card reveal">
                    <div class="event-card-image">
                        <% if (event.getPosterUrl() != null && !event.getPosterUrl().isEmpty()) { %>
                            <img src="<%= event.getPosterUrl() %>" alt="<%= event.getTitle() %>">
                        <% } else { %>
                            <span style="font-size: 3rem;"><%= event.getCategoryName() != null ? event.getCategoryName() : "E" %></span>
                        <% } %>
                        <div class="event-date-badge">
                            <span class="date-day"><%= event.getEventDate() != null ? event.getEventDate().toString().substring(8) : "" %></span>
                            <span class="date-month"><%= event.getEventDate() != null ? event.getEventDate().toString().substring(5, 7) : "" %></span>
                        </div>
                    </div>
                    <div class="event-card-body">
                        <span class="event-category"><%= event.getCategoryName() != null ? event.getCategoryName() : "Event" %></span>
                        <h3><%= event.getTitle() %></h3>
                        <div class="event-meta">
                            <span><%= event.getCity() != null ? event.getCity() : "Location TBD" %></span>
                            <span><%= event.getEventTime() != null ? event.getEventTime().toString() : "TBD" %></span>
                        </div>
                        <div class="event-card-footer">
                            <span class="event-price">
                                <% if (event.getTicketPrice() != null && event.getTicketPrice().doubleValue() > 0) { %>
                                    Rs.<%= event.getTicketPrice() %>
                                <% } else { %>
                                    Free
                                <% } %>
                            </span>
                            <a href="<%= request.getContextPath() %>/EventServlet?action=viewEvent&id=<%= event.getId() %>" class="btn-book">View Details</a>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <div class="no-events">
                    <p>No events found. Please check back later!</p>
                </div>
                <% } %>
            </div>
        </div>
    </section>

    <!-- SCRIPTS -->
    <script src="js/slider.js" defer></script>
    <script>
        function filterByLocation(city) {
            if (city) {
                window.location.href = '<%= request.getContextPath() %>/EventServlet?action=filterByCity&city=' + encodeURIComponent(city);
            } else {
                window.location.href = '<%= request.getContextPath() %>/EventServlet?action=listEvents';
            }
        }
        
        function toggleDropdown() {
            var dropdown = document.getElementById('dropdown-menu');
            var btn = document.getElementById('nav-profile');
            if (dropdown && btn) {
                dropdown.classList.toggle('show');
                btn.classList.toggle('active');
            }
        }

        document.addEventListener('click', function(event) {
            var dropdown = document.getElementById('dropdown-menu');
            var btn = document.getElementById('nav-profile');
            if (dropdown && btn) {
                if (!dropdown.contains(event.target) && !btn.contains(event.target)) {
                    dropdown.classList.remove('show');
                    btn.classList.remove('active');
                }
            }
        });
    </script>

</body>

</html>
