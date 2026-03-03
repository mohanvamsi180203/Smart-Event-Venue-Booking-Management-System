package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.dto.Event;
import com.util.DBConnection;

/**
 * Data Access Object for Event entity
 * Handles all database operations related to events
 */
public class EventDao {

    // SQL Queries - Show all approved events (both past and future for demo)
    private static final String INSERT_EVENT = "INSERT INTO events (title, description, category_id, organizer_id, location, city, venue_name, event_date, event_time, duration_hours, poster_url, ticket_price, total_seats, available_seats, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending')";
    private static final String GET_EVENT_BY_ID = "SELECT e.*, c.name as category_name, o.name as organizer_name FROM events e LEFT JOIN categories c ON e.category_id = c.id LEFT JOIN organizer o ON e.organizer_id = o.id WHERE e.id = ?";
    private static final String GET_ALL_EVENTS = "SELECT e.*, c.name as category_name, o.name as organizer_name FROM events e LEFT JOIN categories c ON e.category_id = c.id LEFT JOIN organizer o ON e.organizer_id = o.id WHERE e.status = 'approved' ORDER BY e.event_date ASC";
    private static final String GET_APPROVED_EVENTS = "SELECT e.*, c.name as category_name, o.name as organizer_name FROM events e LEFT JOIN categories c ON e.category_id = c.id LEFT JOIN organizer o ON e.organizer_id = o.id WHERE e.status = 'approved' ORDER BY e.event_date ASC";
    private static final String GET_EVENTS_BY_CATEGORY = "SELECT e.*, c.name as category_name, o.name as organizer_name FROM events e LEFT JOIN categories c ON e.category_id = c.id LEFT JOIN organizer o ON e.organizer_id = o.id WHERE e.category_id = ? AND e.status = 'approved' ORDER BY e.event_date ASC";
    private static final String GET_EVENTS_BY_CITY = "SELECT e.*, c.name as category_name, o.name as organizer_name FROM events e LEFT JOIN categories c ON e.category_id = c.id LEFT JOIN organizer o ON e.organizer_id = o.id WHERE e.city = ? AND e.status = 'approved' ORDER BY e.event_date ASC";
    private static final String GET_EVENTS_BY_ORGANIZER = "SELECT e.*, c.name as category_name, o.name as organizer_name FROM events e LEFT JOIN categories c ON e.category_id = c.id LEFT JOIN organizer o ON e.organizer_id = o.id WHERE e.organizer_id = ? ORDER BY e.created_at DESC";
    private static final String GET_PENDING_EVENTS = "SELECT e.*, c.name as category_name, o.name as organizer_name FROM events e LEFT JOIN categories c ON e.category_id = c.id LEFT JOIN organizer o ON e.organizer_id = o.id WHERE e.status = 'pending' ORDER BY e.created_at DESC";
    private static final String UPDATE_EVENT = "UPDATE events SET title = ?, description = ?, category_id = ?, location = ?, city = ?, venue_name = ?, event_date = ?, event_time = ?, duration_hours = ?, poster_url = ?, ticket_price = ?, total_seats = ?, available_seats = ? WHERE id = ?";
    private static final String UPDATE_EVENT_STATUS = "UPDATE events SET status = ? WHERE id = ?";
    private static final String UPDATE_AVAILABLE_SEATS = "UPDATE events SET available_seats = available_seats - ? WHERE id = ?";
    private static final String DELETE_EVENT = "DELETE FROM events WHERE id = ?";
    private static final String GET_TOTAL_EVENTS_COUNT = "SELECT COUNT(*) FROM events";
    private static final String GET_APPROVED_EVENTS_COUNT = "SELECT COUNT(*) FROM events WHERE status = 'approved'";
    private static final String GET_PENDING_EVENTS_COUNT = "SELECT COUNT(*) FROM events WHERE status = 'pending'";
    private static final String GET_FEATURED_EVENTS = "SELECT e.*, c.name as category_name, o.name as organizer_name FROM events e LEFT JOIN categories c ON e.category_id = c.id LEFT JOIN organizer o ON e.organizer_id = o.id WHERE e.status = 'approved' AND e.is_featured = 1 ORDER BY e.event_date ASC";
    private static final String GET_EVENTS_BY_CATEGORY_AND_CITY = "SELECT e.*, c.name as category_name, o.name as organizer_name FROM events e LEFT JOIN categories c ON e.category_id = c.id LEFT JOIN organizer o ON e.organizer_id = o.id WHERE e.status = 'approved' AND e.category_id = ? AND e.city = ? ORDER BY e.event_date ASC";
    private static final String GET_UNIQUE_CITIES = "SELECT DISTINCT city FROM events WHERE status = 'approved' ORDER BY city";

    /**
     * Add a new event
     */
    public boolean addEvent(Event event) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(INSERT_EVENT, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, event.getTitle());
            pstmt.setString(2, event.getDescription());
            pstmt.setInt(3, event.getCategoryId());
            pstmt.setInt(4, event.getOrganizerId());
            pstmt.setString(5, event.getLocation());
            pstmt.setString(6, event.getCity());
            pstmt.setString(7, event.getVenueName());
            pstmt.setDate(8, event.getEventDate());
            pstmt.setTime(9, event.getEventTime());
            pstmt.setBigDecimal(10, event.getDurationHours());
            pstmt.setString(11, event.getPosterUrl());
            pstmt.setBigDecimal(12, event.getTicketPrice());
            pstmt.setInt(13, event.getTotalSeats());
            pstmt.setInt(14, event.getAvailableSeats());
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    event.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get event by ID
     */
    public Event getEventById(int id) {
        Event event = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_EVENT_BY_ID)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                event = extractEventFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return event;
    }

    /**
     * Get all events
     */
    public List<Event> getAllEvents() {
        List<Event> events = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_ALL_EVENTS)) {
            
            while (rs.next()) {
                events.add(extractEventFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    /**
     * Get all approved events
     */
    public List<Event> getApprovedEvents() {
        List<Event> events = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_APPROVED_EVENTS)) {
            
            while (rs.next()) {
                events.add(extractEventFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    /**
     * Get events by category
     */
    public List<Event> getEventsByCategory(int categoryId) {
        List<Event> events = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_EVENTS_BY_CATEGORY)) {
            
            pstmt.setInt(1, categoryId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                events.add(extractEventFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    /**
     * Get events by city
     */
    public List<Event> getEventsByCity(String city) {
        List<Event> events = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_EVENTS_BY_CITY)) {
            
            pstmt.setString(1, city);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                events.add(extractEventFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    /**
     * Get events by organizer
     */
    public List<Event> getEventsByOrganizer(int organizerId) {
        List<Event> events = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_EVENTS_BY_ORGANIZER)) {
            
            pstmt.setInt(1, organizerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                events.add(extractEventFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    /**
     * Get pending events
     */
    public List<Event> getPendingEvents() {
        List<Event> events = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_PENDING_EVENTS)) {
            
            while (rs.next()) {
                events.add(extractEventFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    /**
     * Get featured events
     */
    public List<Event> getFeaturedEvents() {
        List<Event> events = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_FEATURED_EVENTS)) {
            
            while (rs.next()) {
                events.add(extractEventFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    /**
     * Update event
     */
    public boolean updateEvent(Event event) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_EVENT)) {
            
            pstmt.setString(1, event.getTitle());
            pstmt.setString(2, event.getDescription());
            pstmt.setInt(3, event.getCategoryId());
            pstmt.setString(4, event.getLocation());
            pstmt.setString(5, event.getCity());
            pstmt.setString(6, event.getVenueName());
            pstmt.setDate(7, event.getEventDate());
            pstmt.setTime(8, event.getEventTime());
            pstmt.setBigDecimal(9, event.getDurationHours());
            pstmt.setString(10, event.getPosterUrl());
            pstmt.setBigDecimal(11, event.getTicketPrice());
            pstmt.setInt(12, event.getTotalSeats());
            pstmt.setInt(13, event.getAvailableSeats());
            pstmt.setInt(14, event.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update event status
     */
    public boolean updateStatus(int eventId, String status) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_EVENT_STATUS)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, eventId);
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update available seats after booking
     */
    public boolean updateAvailableSeats(int eventId, int ticketsBooked) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_AVAILABLE_SEATS)) {
            
            pstmt.setInt(1, ticketsBooked);
            pstmt.setInt(2, eventId);
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete event
     */
    public boolean deleteEvent(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(DELETE_EVENT)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get total events count
     */
    public int getTotalEventsCount() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_TOTAL_EVENTS_COUNT)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get approved events count
     */
    public int getApprovedEventsCount() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_APPROVED_EVENTS_COUNT)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get pending events count
     */
    public int getPendingEventsCount() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_PENDING_EVENTS_COUNT)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Get events by category and city combined
     */
    public List<Event> getEventsByCategoryAndCity(int categoryId, String city) {
        List<Event> events = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_EVENTS_BY_CATEGORY_AND_CITY)) {
            
            pstmt.setInt(1, categoryId);
            pstmt.setString(2, city);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                events.add(extractEventFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }
    
    /**
     * Get unique cities from events
     */
    public List<String> getUniqueCities() {
        List<String> cities = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_UNIQUE_CITIES)) {
            
            while (rs.next()) {
                cities.add(rs.getString("city"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cities;
    }

    /**
     * Helper method to extract Event from ResultSet
     */
    private Event extractEventFromResultSet(ResultSet rs) throws SQLException {
        Event event = new Event();
        event.setId(rs.getInt("id"));
        event.setTitle(rs.getString("title"));
        event.setDescription(rs.getString("description"));
        event.setCategoryId(rs.getInt("category_id"));
        event.setCategoryName(rs.getString("category_name"));
        event.setOrganizerId(rs.getInt("organizer_id"));
        event.setOrganizerName(rs.getString("organizer_name"));
        event.setLocation(rs.getString("location"));
        event.setCity(rs.getString("city"));
        event.setVenueName(rs.getString("venue_name"));
        event.setEventDate(rs.getDate("event_date"));
        event.setEventTime(rs.getTime("event_time"));
        event.setDurationHours(rs.getBigDecimal("duration_hours"));
        event.setPosterUrl(rs.getString("poster_url"));
        event.setTicketPrice(rs.getBigDecimal("ticket_price"));
        event.setTotalSeats(rs.getInt("total_seats"));
        event.setAvailableSeats(rs.getInt("available_seats"));
        event.setStatus(rs.getString("status"));
        event.setFeatured(rs.getBoolean("is_featured"));
        event.setCreatedAt(rs.getTimestamp("created_at"));
        event.setUpdatedAt(rs.getTimestamp("updated_at"));
        return event;
    }
}
