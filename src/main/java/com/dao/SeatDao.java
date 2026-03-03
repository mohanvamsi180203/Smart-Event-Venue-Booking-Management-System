package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.dto.Seat;
import com.util.DBConnection;

public class SeatDao {
    
    public List<Seat> getSeatsByEventId(int eventId) throws Exception {
        List<Seat> seats = new ArrayList<>();
        
        // First check if seats exist, if not generate them
        seats = getExistingSeats(eventId);
        
        if (seats.isEmpty()) {
            // Generate seats for this event automatically
            generateSeatsForEvent(eventId);
            seats = getExistingSeats(eventId);
        }
        
        return seats;
    }
    
    private List<Seat> getExistingSeats(int eventId) throws Exception {
        List<Seat> seats = new ArrayList<>();
        String sql = "SELECT * FROM event_seats WHERE event_id = ? ORDER BY row_label, seat_column";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Seat seat = extractSeatFromResultSet(rs);
                seats.add(seat);
            }
        }
        return seats;
    }
    
    private void generateSeatsForEvent(int eventId) throws Exception {
        // Get total seats from event
        Connection conn = null;
        int totalSeats = 50; // default
        String venueName = "Stadium";
        
        try {
            conn = DBConnection.getConnection();
            
            // Get event info
            String eventSql = "SELECT total_seats, venue_name FROM events WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(eventSql)) {
                ps.setInt(1, eventId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    totalSeats = rs.getInt("total_seats");
                    if (totalSeats <= 0) totalSeats = 50;
                    String venue = rs.getString("venue_name");
                    if (venue != null) venueName = venue;
                }
            }
            
            // Calculate rows and seats per row (aim for ~10 seats per row)
            int seatsPerRow = 10;
            int numRows = (int) Math.ceil((double) totalSeats / seatsPerRow);
            if (numRows > 26) numRows = 26; // Limit to A-Z
            
            // Generate seats
            conn.setAutoCommit(false);
            
            String insertSql = "INSERT INTO event_seats (event_id, seat_number, row_label, seat_column, status) VALUES (?, ?, ?, ?, 'AVAILABLE')";
            
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                for (int row = 1; row <= numRows; row++) {
                    char rowLabel = (char) ('A' + row - 1);
                    for (int col = 1; col <= seatsPerRow; col++) {
                        int seatNum = (row - 1) * seatsPerRow + col;
                        if (seatNum > totalSeats) break;
                        
                        ps.setInt(1, eventId);
                        ps.setString(2, rowLabel + String.valueOf(col));
                        ps.setString(3, String.valueOf(rowLabel));
                        ps.setInt(4, col);
                        ps.addBatch();
                    }
                }
                ps.executeBatch();
            }
            
            conn.commit();
            System.out.println("Auto-generated seats for event " + eventId);
            
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
    
    public List<Seat> getAvailableSeats(int eventId) throws Exception {
        List<Seat> seats = new ArrayList<>();
        String sql = "SELECT * FROM event_seats WHERE event_id = ? AND status = 'AVAILABLE' ORDER BY row_label, seat_column";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Seat seat = extractSeatFromResultSet(rs);
                seats.add(seat);
            }
        }
        return seats;
    }
    
    public boolean lockSeats(int eventId, List<String> seatNumbers, int userId) throws Exception {
        Connection conn = null;
        boolean success = true;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            String releaseSql = "UPDATE event_seats SET status = 'AVAILABLE', locked_by = NULL, lock_time = NULL " +
                              "WHERE status = 'LOCKED' AND lock_time < DATE_SUB(NOW(), INTERVAL 5 MINUTE)";
            try (PreparedStatement ps = conn.prepareStatement(releaseSql)) {
                ps.executeUpdate();
            }
            
            String lockSql = "UPDATE event_seats SET status = 'LOCKED', locked_by = ?, lock_time = NOW() " +
                            "WHERE event_id = ? AND seat_number = ? AND status = 'AVAILABLE'";
            
            try (PreparedStatement ps = conn.prepareStatement(lockSql)) {
                for (String seatNumber : seatNumbers) {
                    ps.setInt(1, userId);
                    ps.setInt(2, eventId);
                    ps.setString(3, seatNumber);
                    int updated = ps.executeUpdate();
                    if (updated == 0) {
                        success = false;
                        break;
                    }
                }
            }
            
            if (success) {
                conn.commit();
            } else {
                conn.rollback();
            }
            
        } catch (Exception e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
        
        return success;
    }
    
    public void unlockSeats(int eventId, List<String> seatNumbers, int userId) throws Exception {
        String sql = "UPDATE event_seats SET status = 'AVAILABLE', locked_by = NULL, lock_time = NULL " +
                    "WHERE event_id = ? AND seat_number = ? AND locked_by = ? AND status = 'LOCKED'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (String seatNumber : seatNumbers) {
                ps.setInt(1, eventId);
                ps.setString(2, seatNumber);
                ps.setInt(3, userId);
                ps.executeUpdate();
            }
        }
    }
    
    public boolean bookSeats(int eventId, List<String> seatNumbers, int userId, int bookingId) throws Exception {
        Connection conn = null;
        boolean success = true;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            double ticketPrice = 0;
            String priceSql = "SELECT ticket_price FROM events WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(priceSql)) {
                ps.setInt(1, eventId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    ticketPrice = rs.getDouble("ticket_price");
                }
            }
            
            String updateSeatSql = "UPDATE event_seats SET status = 'BOOKED', booking_id = ?, locked_by = NULL, lock_time = NULL " +
                                  "WHERE event_id = ? AND seat_number = ? AND locked_by = ? AND status = 'LOCKED'";
            
            String insertBookingSeatSql = "INSERT INTO booking_seats (booking_id, seat_id, seat_number, price) " +
                                        "SELECT ?, seat_id, seat_number, ? FROM event_seats " +
                                        "WHERE event_id = ? AND seat_number = ?";
            
            for (String seatNumber : seatNumbers) {
                try (PreparedStatement ps = conn.prepareStatement(updateSeatSql)) {
                    ps.setInt(1, bookingId);
                    ps.setInt(2, eventId);
                    ps.setString(3, seatNumber);
                    ps.setInt(4, userId);
                    int updated = ps.executeUpdate();
                    
                    if (updated == 0) {
                        success = false;
                        break;
                    }
                }
                
                try (PreparedStatement ps = conn.prepareStatement(insertBookingSeatSql)) {
                    ps.setInt(1, bookingId);
                    ps.setDouble(2, ticketPrice);
                    ps.setInt(3, eventId);
                    ps.setString(4, seatNumber);
                    ps.executeUpdate();
                }
            }
            
            String updateEventSql = "UPDATE events SET available_seats = available_seats - ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateEventSql)) {
                ps.setInt(1, seatNumbers.size());
                ps.setInt(2, eventId);
                ps.executeUpdate();
            }
            
            if (success) {
                conn.commit();
            } else {
                conn.rollback();
            }
            
        } catch (Exception e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
        
        return success;
    }
    
    public boolean areSeatsLockedByUser(int eventId, List<String> seatNumbers, int userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM event_seats WHERE event_id = ? AND seat_number = ? " +
                    "AND locked_by = ? AND status = 'LOCKED' " +
                    "AND lock_time > DATE_SUB(NOW(), INTERVAL 5 MINUTE)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (String seatNumber : seatNumbers) {
                ps.setInt(1, eventId);
                ps.setString(2, seatNumber);
                ps.setInt(3, userId);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next() && rs.getInt(1) == 0) {
                    return false;
                }
            }
        }
        return true;
    }
    
    public List<String> getBookedSeatNumbers(int bookingId) throws Exception {
        List<String> seats = new ArrayList<>();
        String sql = "SELECT seat_number FROM booking_seats WHERE booking_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                seats.add(rs.getString("seat_number"));
            }
        }
        return seats;
    }
    
    private Seat extractSeatFromResultSet(ResultSet rs) throws SQLException {
        Seat seat = new Seat();
        seat.setSeatId(rs.getInt("seat_id"));
        seat.setEventId(rs.getInt("event_id"));
        seat.setSeatNumber(rs.getString("seat_number"));
        seat.setRowLabel(rs.getString("row_label"));
        seat.setSeatColumn(rs.getInt("seat_column"));
        seat.setStatus(rs.getString("status"));
        
        int lockedBy = rs.getInt("locked_by");
        if (!rs.wasNull()) {
            seat.setLockedBy(lockedBy);
        }
        
        seat.setLockTime(rs.getTimestamp("lock_time"));
        
        int bookingId = rs.getInt("booking_id");
        if (!rs.wasNull()) {
            seat.setBookingId(bookingId);
        }
        
        return seat;
    }
}
