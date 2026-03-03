<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-brand">
                <h2 class="logo">EventHub</h2>
                <p>Your premier destination for discovering, booking, and managing events and venues.</p>
            </div>
            
            <div class="footer-column">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/index.jsp">Home</a></li>
                    <li><a href="<%= request.getContextPath() %>/EventServlet?action=listEvents">Browse Events</a></li>
                    <li><a href="<%= request.getContextPath() %>/organizer-signup.jsp">Become an Organizer</a></li>
                </ul>
            </div>
            
            <div class="footer-column">
                <h4>For Users</h4>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/user-login.jsp">Login</a></li>
                    <li><a href="<%= request.getContextPath() %>/user-signup.jsp">Register</a></li>
                    <li><a href="<%= request.getContextPath() %>/EventServlet?action=myBookings">My Bookings</a></li>
                </ul>
            </div>
            
            <div class="footer-column">
                <h4>For Organizers</h4>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/organizer-login.jsp">Organizer Login</a></li>
                    <li><a href="<%= request.getContextPath() %>/organizer-signup.jsp">Register as Organizer</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin-login.jsp">Admin Login</a></li>
                </ul>
            </div>
        </div>
        
        <div class="footer-bottom">
            <p>&copy; 2026 EventHub. All rights reserved.</p>
        </div>
    </div>
</footer>
