package com.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.dto.Booking;
import com.util.DBConnection;

/**
 * Data Access Object for Booking entity
 * Handles all database operations related to bookings
 */
public class BookingDao {

    // SQL Queries
    private static final String INSERT_BOOKING = "INSERT INTO bookings (user_id, event_id, booking_reference, number_of_tickets, total_amount, booking_status, payment_status, event_date) VALUES (?, ?, ?, ?, ?, 'confirmed', 'paid', ?)";
    private static final String GET_BOOKING_BY_ID = "SELECT b.*, u.name as user_name, u.email as user_email, e.title as event_title, e.event_date as booking_event_date FROM bookings b LEFT JOIN users u ON b.user_id = u.id LEFT JOIN events e ON b.event_id = e.id WHERE b.id = ?";
    private static final String GET_BOOKING_BY_REFERENCE = "SELECT b.*, u.name as user_name, u.email as user_email, e.title as event_title, e.event_date as booking_event_date FROM bookings b LEFT JOIN users u ON b.user_id = u.id LEFT JOIN events e ON b.event_id = e.id WHERE b.booking_reference = ?";
    private static final String GET_BOOKINGS_BY_USER = "SELECT b.*, u.name as user_name, u.email as user_email, e.title as event_title, e.event_date as booking_event_date FROM bookings b LEFT JOIN users u ON b.user_id = u.id LEFT JOIN events e ON b.event_id = e.id WHERE b.user_id = ? ORDER BY b.booking_date DESC";
    private static final String GET_BOOKINGS_BY_EVENT = "SELECT b.*, u.name as user_name, u.email as user_email, e.title as event_title, e.event_date as booking_event_date FROM bookings b LEFT JOIN users u ON b.user_id = u.id LEFT JOIN events e ON b.event_id = e.id WHERE b.event_id = ? ORDER BY b.booking_date DESC";
    private static final String GET_ALL_BOOKINGS = "SELECT b.*, u.name as user_name, u.email as user_email, e.title as event_title, e.event_date as booking_event_date FROM bookings b LEFT JOIN users u ON b.user_id = u.id LEFT JOIN events e ON b.event_id = e.id ORDER BY b.booking_date DESC";
    private static final String UPDATE_BOOKING_STATUS = "UPDATE bookings SET booking_status = ? WHERE id = ?";
    private static final String UPDATE_PAYMENT_STATUS = "UPDATE bookings SET payment_status = ?, payment_id = ? WHERE id = ?";
    private static final String DELETE_BOOKING = "DELETE FROM bookings WHERE id = ?";
    private static final String GET_TOTAL_BOOKINGS_COUNT = "SELECT COUNT(*) FROM bookings";
    private static final String GET_TOTAL_REVENUE = "SELECT SUM(total_amount) FROM bookings WHERE payment_status = 'paid'";
    private static final String GET_BOOKINGS_BY_STATUS = "SELECT b.*, u.name as user_name, u.email as user_email, e.title as event_title, e.event_date as booking_event_date FROM bookings b LEFT JOIN users u ON b.user_id = u.id LEFT JOIN events e ON b.event_id = e.id WHERE b.booking_status = ? ORDER BY b.booking_date DESC";

    /**
     * Create a new booking
     */
    public boolean createBooking(Booking booking) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(INSERT_BOOKING, Statement.RETURN_GENERATED_KEYS)) {
            
            // Generate unique booking reference
            String bookingRef = "EVT" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            
            pstmt.setInt(1, booking.getUserId());
            pstmt.setInt(2, booking.getEventId());
            pstmt.setString(3, bookingRef);
            pstmt.setInt(4, booking.getNumberOfTickets());
            pstmt.setBigDecimal(5, booking.getTotalAmount());
            pstmt.setDate(6, booking.getEventDate());
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    booking.setId(rs.getInt(1));
                    booking.setBookingReference(bookingRef);
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get booking by ID
     */
    public Booking getBookingById(int id) {
        Booking booking = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_BOOKING_BY_ID)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                booking = extractBookingFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return booking;
    }

    /**
     * Get booking by reference
     */
    public Booking getBookingByReference(String reference) {
        Booking booking = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_BOOKING_BY_REFERENCE)) {
            
            pstmt.setString(1, reference);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                booking = extractBookingFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return booking;
    }

    /**
     * Get bookings by user
     */
    public List<Booking> getBookingsByUser(int userId) {
        List<Booking> bookings = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_BOOKINGS_BY_USER)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bookings;
    }

    /**
     * Get bookings by event
     */
    public List<Booking> getBookingsByEvent(int eventId) {
        List<Booking> bookings = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_BOOKINGS_BY_EVENT)) {
            
            pstmt.setInt(1, eventId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bookings;
    }

    /**
     * Get all bookings
     */
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_ALL_BOOKINGS)) {
            
            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bookings;
    }

    /**
     * Get bookings by status
     */
    public List<Booking> getBookingsByStatus(String status) {
        List<Booking> bookings = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_BOOKINGS_BY_STATUS)) {
            
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bookings;
    }

    /**
     * Update booking status
     */
    public boolean updateBookingStatus(int bookingId, String status) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_BOOKING_STATUS)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, bookingId);
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update payment status
     */
    public boolean updatePaymentStatus(int bookingId, String paymentStatus, String paymentId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_PAYMENT_STATUS)) {
            
            pstmt.setString(1, paymentStatus);
            pstmt.setString(2, paymentId);
            pstmt.setInt(3, bookingId);
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete booking
     */
    public boolean deleteBooking(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(DELETE_BOOKING)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get total bookings count
     */
    public int getTotalBookingsCount() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_TOTAL_BOOKINGS_COUNT)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get total revenue
     */
    public double getTotalRevenue() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_TOTAL_REVENUE)) {
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Helper method to extract Booking from ResultSet
     */
    private Booking extractBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setId(rs.getInt("id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setUserName(rs.getString("user_name"));
        booking.setUserEmail(rs.getString("user_email"));
        booking.setEventId(rs.getInt("event_id"));
        booking.setEventTitle(rs.getString("event_title"));
        booking.setBookingReference(rs.getString("booking_reference"));
        booking.setNumberOfTickets(rs.getInt("number_of_tickets"));
        booking.setTotalAmount(rs.getBigDecimal("total_amount"));
        booking.setBookingStatus(rs.getString("booking_status"));
        booking.setPaymentMethod(rs.getString("payment_method"));
        booking.setPaymentStatus(rs.getString("payment_status"));
        booking.setPaymentId(rs.getString("payment_id"));
        booking.setBookingDate(rs.getTimestamp("booking_date"));
        
        Date eventDate = rs.getDate("booking_event_date");
        if (eventDate != null) {
            booking.setEventDate(eventDate);
        }
        
        return booking;
    }
}
