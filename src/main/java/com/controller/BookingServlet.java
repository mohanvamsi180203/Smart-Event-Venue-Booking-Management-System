package com.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.dao.EventDao;
import com.dao.SeatDao;
import com.dto.Event;
import com.dto.Seat;
import com.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            sendJsonResponse(response, false, "User not logged in. Please login first.");
            return;
        }
        
        String action = request.getParameter("action");
        
        // Null check - return JSON error if action is null
        if (action == null) {
            sendJsonResponse(response, false, "Action parameter is required");
            return;
        }
        
        try {
            switch (action) {
                case "getSeats":
                    getEventSeats(request, response);
                    break;
                case "lockSeats":
                    lockSeats(request, response, userId);
                    break;
                case "unlockSeats":
                    unlockSeats(request, response, userId);
                    break;
                case "bookSeats":
                    bookSeats(request, response, userId);
                    break;
                default:
                    sendJsonResponse(response, false, "Unknown action: " + action);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Error: " + e.getMessage());
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Return 405 Method Not Allowed for GET requests
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        PrintWriter out = response.getWriter();
        out.print("{\"error\":\"GET method not allowed. Use POST.\"}");
    }
    
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
    }
    
    private void getEventSeats(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        SeatDao seatDao = new SeatDao();
        List<Seat> seats = seatDao.getSeatsByEventId(eventId);
        
        StringBuilder json = new StringBuilder();
        json.append("{\"seats\":[");
        
        for (int i = 0; i < seats.size(); i++) {
            Seat seat = seats.get(i);
            if (i > 0) json.append(",");
            
            json.append("{");
            json.append("\"seatId\":").append(seat.getSeatId()).append(",");
            json.append("\"seatNumber\":\"").append(seat.getSeatNumber()).append("\",");
            json.append("\"rowLabel\":\"").append(seat.getRowLabel()).append("\",");
            json.append("\"seatColumn\":").append(seat.getSeatColumn()).append(",");
            json.append("\"status\":\"").append(seat.getStatus()).append("\"");
            
            if (seat.isLocked() && seat.getLockedBy() != null) {
                json.append(",\"lockedBy\":").append(seat.getLockedBy());
                if (userId != null && seat.getLockedBy().equals(userId)) {
                    json.append(",\"lockedByCurrentUser\":true");
                }
            }
            
            json.append("}");
        }
        
        json.append("]}");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json.toString());
    }
    
    private void lockSeats(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws Exception {
        
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String seatsParam = request.getParameter("seats");
        List<String> seatNumbers = parseSeatNumbers(seatsParam);
        
        SeatDao seatDao = new SeatDao();
        boolean success = seatDao.lockSeats(eventId, seatNumbers, userId);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (success) {
            response.getWriter().write("{\"success\":true,\"message\":\"Seats locked successfully\"}");
        } else {
            response.getWriter().write("{\"success\":false,\"message\":\"Some seats are no longer available\"}");
        }
    }
    
    private void unlockSeats(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws Exception {
        
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String seatsParam = request.getParameter("seats");
        List<String> seatNumbers = parseSeatNumbers(seatsParam);
        
        SeatDao seatDao = new SeatDao();
        seatDao.unlockSeats(eventId, seatNumbers, userId);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":true}");
    }
    
    private void bookSeats(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws Exception {
        
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String seatsParam = request.getParameter("seats");
        List<String> seatNumbers = parseSeatNumbers(seatsParam);
        
        SeatDao seatDao = new SeatDao();
        
        if (!seatDao.areSeatsLockedByUser(eventId, seatNumbers, userId)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\":false,\"message\":\"Your seat reservation has expired. Please select seats again.\"}");
            return;
        }
        
        EventDao eventDao = new EventDao();
        Event event = eventDao.getEventById(eventId);
        double totalAmount = seatNumbers.size() * event.getTicketPrice().doubleValue();
        
        Connection conn = null;
        int bookingId = 0;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            String bookingRef = "EVT" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            
            String sql = "INSERT INTO bookings (user_id, event_id, booking_reference, number_of_tickets, total_amount, booking_status, payment_status, event_date) VALUES (?, ?, ?, ?, ?, 'confirmed', 'paid', ?)";
            
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setInt(2, eventId);
                ps.setString(3, bookingRef);
                ps.setInt(4, seatNumbers.size());
                ps.setDouble(5, totalAmount);
                ps.setDate(6, new java.sql.Date(event.getEventDate().getTime()));
                ps.executeUpdate();
                
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    bookingId = rs.getInt(1);
                }
            }
            
            if (bookingId > 0) {
                boolean success = seatDao.bookSeats(eventId, seatNumbers, userId, bookingId);
                
                if (success) {
                    conn.commit();
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\":true,\"message\":\"Booking confirmed\",\"bookingId\":" + bookingId + "}");
                } else {
                    conn.rollback();
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\":false,\"message\":\"Failed to complete booking. Please try again.\"}");
                }
            } else {
                conn.rollback();
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"Failed to create booking. Please try again.\"}");
            }
            
        } catch (Exception e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }
    
    private List<String> parseSeatNumbers(String seatsParam) {
        List<String> seatNumbers = new ArrayList<>();
        if (seatsParam != null && !seatsParam.trim().isEmpty()) {
            String[] parts = seatsParam.split(",");
            for (String part : parts) {
                String seatNumber = part.trim();
                if (!seatNumber.isEmpty()) {
                    seatNumbers.add(seatNumber);
                }
            }
        }
        return seatNumbers;
    }
}
