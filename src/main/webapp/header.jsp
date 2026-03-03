<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    Integer adminId = (Integer) session.getAttribute("adminId");
    Integer organizerId = (Integer) session.getAttribute("organizerId");
%>
<header class="navbar">
    <div class="nav-left">
        <a href="<%= request.getContextPath() %>/index.jsp" class="logo">EventHub</a>
    </div>
    
    <div class="nav-center">
        <a href="<%= request.getContextPath() %>/EventServlet?action=listEvents" class="nav-link">Browse Events</a>
    </div>
    
    <div class="nav-right">
        <% if (userId != null) { %>
            <div class="user-profile-dropdown">
                <button class="profile-btn" onclick="toggleDropdown()">
                    <span class="profile-avatar">👤</span>
                    <span><%= userName %></span>
                    <span class="dropdown-arrow">▼</span>
                </button>
                <div class="dropdown-menu" id="dropdown-menu">
                    <a href="<%= request.getContextPath() %>/ProfileServlet" class="dropdown-item">My Profile</a>
                    <a href="<%= request.getContextPath() %>/EventServlet?action=myBookings" class="dropdown-item">My Bookings</a>
                    <div class="dropdown-divider"></div>
                    <a href="<%= request.getContextPath() %>/UserServlet?action=logout" class="dropdown-item logout">Logout</a>
                </div>
            </div>
        <% } else if (adminId != null) { %>
            <a href="<%= request.getContextPath() %>/AdminServlet?action=dashboard" class="btn-outline">Admin Panel</a>
            <a href="<%= request.getContextPath() %>/AdminServlet?action=logout" class="btn-outline">Logout</a>
        <% } else if (organizerId != null) { %>
            <a href="<%= request.getContextPath() %>/OrganizerServlet?action=dashboard" class="btn-outline">Organizer Panel</a>
            <a href="<%= request.getContextPath() %>/OrganizerServlet?action=logout" class="btn-outline">Logout</a>
        <% } else { %>
            <div class="auth-buttons">
                <a href="<%= request.getContextPath() %>/user-login.jsp" class="btn-outline">Login</a>
                <a href="<%= request.getContextPath() %>/user-signup.jsp" class="btn-primary">Sign Up</a>
            </div>
        <% } %>
    </div>
</header>

<script>
    function toggleDropdown() {
        var dropdown = document.getElementById('dropdown-menu');
        dropdown.classList.toggle('show');
    }
    
    document.addEventListener('click', function(event) {
        var dropdown = document.getElementById('dropdown-menu');
        var btn = document.querySelector('.profile-btn');
        if (dropdown && btn) {
            if (!dropdown.contains(event.target) && !btn.contains(event.target)) {
                dropdown.classList.remove('show');
            }
        }
    });
</script>
