<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.dto.*" %>
<%
    // Check if user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/user-login.jsp?error=Please login to view your bookings!");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings | EventHub</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/user-style.css">
</head>
<body>
    <jsp:include page="../header.jsp" />

    <div class="container">
        <div class="my-bookings-page">
            <h1>My Bookings</h1>
            
            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success">
                    <%= request.getParameter("success") %>
                </div>
            <% } %>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getParameter("error") %>
                </div>
            <% } %>
            
            <% if (bookings != null && !bookings.isEmpty()) { %>
                <div class="bookings-list">
                    <% for (Booking booking : bookings) { %>
                    <div class="booking-card">
                        <div class="booking-info">
                            <h3><%= booking.getEventTitle() != null ? booking.getEventTitle() : "Event #" + booking.getEventId() %></h3>
                            <p class="booking-ref">Reference: <strong><%= booking.getBookingReference() %></strong></p>
                            <div class="booking-details">
                                <span>📅 <%= booking.getEventDate() != null ? booking.getEventDate().toString() : "N/A" %></span>
                                <span>🎫 <%= booking.getNumberOfTickets() %> Ticket(s)</span>
                                <span>💰 ₹<%= booking.getTotalAmount() %></span>
                            </div>
                        </div>
                        <div class="booking-status">
                            <span class="status-badge <%= booking.getBookingStatus() %>">
                                <%= booking.getBookingStatus() != null ? booking.getBookingStatus().toUpperCase() : "CONFIRMED" %>
                            </span>
                        </div>
                    </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="no-bookings">
                    <h3>No bookings yet</h3>
                    <p>You haven't made any bookings yet. Browse events and book your first ticket!</p>
                    <a href="<%= request.getContextPath() %>/EventServlet?action=listEvents" class="btn-primary">Browse Events</a>
                </div>
            <% } %>
        </div>
    </div>

    <jsp:include page="../footer.jsp" />
</body>
</html>
