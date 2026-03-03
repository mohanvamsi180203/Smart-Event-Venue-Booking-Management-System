package com.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import com.dao.BookingDao;
import com.dao.CategoryDao;
import com.dao.EventDao;
import com.dto.Booking;
import com.dto.Category;
import com.dto.Event;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Event Servlet - Handles event browsing and booking for users
 */
@WebServlet("/EventServlet")
public class EventServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private EventDao eventDao;
    private CategoryDao categoryDao;
    private BookingDao bookingDao;
    
    // Action constants
    private static final String ACTION_LIST_EVENTS = "listEvents";
    private static final String ACTION_VIEW_EVENT = "viewEvent";
    private static final String ACTION_BOOK_TICKET = "bookTicket";
    private static final String ACTION_MY_BOOKINGS = "myBookings";
    private static final String ACTION_FILTER_BY_CATEGORY = "filterByCategory";
    private static final String ACTION_FILTER_BY_CITY = "filterByCity";
    private static final String ACTION_SEARCH = "search";
    
    @Override
    public void init() throws ServletException {
        eventDao = new EventDao();
        categoryDao = new CategoryDao();
        bookingDao = new BookingDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = ACTION_LIST_EVENTS;
        }
        
        switch (action) {
            case ACTION_LIST_EVENTS:
                listEvents(request, response);
                break;
            case ACTION_VIEW_EVENT:
                viewEvent(request, response);
                break;
            case ACTION_MY_BOOKINGS:
                myBookings(request, response);
                break;
            case ACTION_FILTER_BY_CATEGORY:
                filterByCategory(request, response);
                break;
            case ACTION_FILTER_BY_CITY:
                filterByCity(request, response);
                break;
            case ACTION_SEARCH:
                searchEvents(request, response);
                break;
            default:
                listEvents(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("EventServlet");
            return;
        }
        
        switch (action) {
            case ACTION_BOOK_TICKET:
                bookTicket(request, response);
                break;
            default:
                response.sendRedirect("EventServlet");
        }
    }
    
    /**
     * List all approved events
     */
    private void listEvents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Event> events = eventDao.getApprovedEvents();
        List<Category> categories = categoryDao.getActiveCategories();
        
        request.setAttribute("events", events);
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/events/events-list.jsp").forward(request, response);
    }
    
    /**
     * View event details
     */
    private void viewEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int eventId = Integer.parseInt(request.getParameter("id"));
        Event event = eventDao.getEventById(eventId);
        
        if (event == null) {
            response.sendRedirect(request.getContextPath() + "/EventServlet?error=Event not found!");
            return;
        }
        
        request.setAttribute("event", event);
        request.getRequestDispatcher("/events/event-details.jsp").forward(request, response);
    }
    
    /**
     * Filter events by category
     */
    private void filterByCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        List<Event> events = eventDao.getEventsByCategory(categoryId);
        List<Category> categories = categoryDao.getActiveCategories();
        
        request.setAttribute("events", events);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", categoryId);
        
        request.getRequestDispatcher("/events/events-list.jsp").forward(request, response);
    }
    
    /**
     * Filter events by city
     */
    private void filterByCity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String city = request.getParameter("city");
        List<Event> events = eventDao.getEventsByCity(city);
        List<Category> categories = categoryDao.getActiveCategories();
        
        request.setAttribute("events", events);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCity", city);
        
        request.getRequestDispatcher("/events/events-list.jsp").forward(request, response);
    }
    
    /**
     * Search events
     */
    private void searchEvents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String query = request.getParameter("query");
        List<Event> allEvents = eventDao.getApprovedEvents();
        
        // Simple search by title or description
        List<Event> events = allEvents.stream()
            .filter(e -> e.getTitle().toLowerCase().contains(query.toLowerCase()) ||
                        (e.getDescription() != null && e.getDescription().toLowerCase().contains(query.toLowerCase())) ||
                        e.getCity().toLowerCase().contains(query.toLowerCase()))
            .collect(java.util.stream.Collectors.toList());
        
        List<Category> categories = categoryDao.getActiveCategories();
        
        request.setAttribute("events", events);
        request.setAttribute("categories", categories);
        request.setAttribute("searchQuery", query);
        
        request.getRequestDispatcher("/events/events-list.jsp").forward(request, response);
    }
    
    /**
     * Book tickets
     */
    private void bookTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/user-login.jsp?error=Please login to book tickets!");
            return;
        }
        
        try {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            int numberOfTickets = Integer.parseInt(request.getParameter("numberOfTickets"));
            
            Event event = eventDao.getEventById(eventId);
            
            if (event == null) {
                response.sendRedirect(request.getContextPath() + "/EventServlet?error=Event not found!");
                return;
            }
            
            // Check availability
            if (event.getAvailableSeats() < numberOfTickets) {
                response.sendRedirect(request.getContextPath() + "/EventServlet?action=viewEvent&id=" + eventId + "&error=Not enough seats available!");
                return;
            }
            
            // Calculate total amount
            BigDecimal totalAmount = event.getTicketPrice().multiply(new BigDecimal(numberOfTickets));
            
            // Get payment method
            String paymentMethod = request.getParameter("paymentMethod");
            if (paymentMethod == null) paymentMethod = "card";
            
            int userId = (Integer) session.getAttribute("userId");
            
            // Create booking
            Booking booking = new Booking(userId, eventId, null, numberOfTickets, totalAmount);
            booking.setEventDate(event.getEventDate());
            booking.setPaymentMethod(paymentMethod);
            booking.setPaymentStatus("paid");
            
            boolean success = bookingDao.createBooking(booking);
            
            if (success) {
                // Update available seats
                eventDao.updateAvailableSeats(eventId, numberOfTickets);
                
                response.sendRedirect(request.getContextPath() + "/EventServlet?action=myBookings&success=Booking successful! Reference: " + booking.getBookingReference());
            } else {
                response.sendRedirect(request.getContextPath() + "/EventServlet?action=viewEvent&id=" + eventId + "&error=Booking failed!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/EventServlet?error=Invalid input data!");
        }
    }
    
    /**
     * Show user's bookings
     */
    private void myBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/user-login.jsp?error=Please login to view your bookings!");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        List<Booking> bookings = bookingDao.getBookingsByUser(userId);
        
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/user/my-bookings.jsp").forward(request, response);
    }
}
