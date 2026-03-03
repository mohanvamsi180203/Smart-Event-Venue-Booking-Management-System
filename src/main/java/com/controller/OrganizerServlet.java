package com.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.dao.CategoryDao;
import com.dao.EventDao;
import com.dao.OrganizerDao;
import com.dto.Category;
import com.dto.Event;
import com.dto.Organizer;
import com.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Organizer Servlet - Handles all organizer operations
 */
@WebServlet("/OrganizerServlet")
public class OrganizerServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private OrganizerDao organizerDao;
    private EventDao eventDao;
    private CategoryDao categoryDao;
    
    // Action constants
    private static final String ACTION_REGISTER = "register";
    private static final String ACTION_LOGIN = "login";
    private static final String ACTION_LOGOUT = "logout";
    private static final String ACTION_DASHBOARD = "dashboard";
    private static final String ACTION_ADD_EVENT = "addEvent";
    private static final String ACTION_EDIT_EVENT = "editEvent";
    private static final String ACTION_UPDATE_EVENT = "updateEvent";
    private static final String ACTION_DELETE_EVENT = "deleteEvent";
    private static final String ACTION_VIEW_MY_EVENTS = "viewMyEvents";
    
    @Override
    public void init() throws ServletException {
        organizerDao = new OrganizerDao();
        eventDao = new EventDao();
        categoryDao = new CategoryDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = ACTION_DASHBOARD;
        }
        
        switch (action) {
            case ACTION_LOGOUT:
                handleLogout(request, response);
                break;
            case ACTION_DASHBOARD:
            case ACTION_VIEW_MY_EVENTS:
            case ACTION_EDIT_EVENT:
                handleGetRequest(request, response, action);
                break;
            default:
                response.sendRedirect("organizer-login.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("organizer-login.jsp");
            return;
        }
        
        switch (action) {
            case ACTION_REGISTER:
                handleRegistration(request, response);
                break;
            case ACTION_LOGIN:
                handleLogin(request, response);
                break;
            case ACTION_ADD_EVENT:
                handleAddEvent(request, response);
                break;
            case ACTION_UPDATE_EVENT:
                handleUpdateEvent(request, response);
                break;
            case ACTION_DELETE_EVENT:
                handleDeleteEvent(request, response);
                break;
            default:
                response.sendRedirect("organizer-login.jsp");
        }
    }
    
    /**
     * Handle organizer registration
     */
    private void handleRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String companyName = request.getParameter("companyName");
        String address = request.getParameter("address");
        
        // Validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "All required fields must be filled!");
            request.getRequestDispatcher("organizer-signup.jsp").forward(request, response);
            return;
        }
        
        // Check password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("organizer-signup.jsp").forward(request, response);
            return;
        }
        
        // Check password length
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters!");
            request.getRequestDispatcher("organizer-signup.jsp").forward(request, response);
            return;
        }
        
        // Check if email already exists
        if (organizerDao.emailExists(email)) {
            request.setAttribute("error", "Email already registered!");
            request.getRequestDispatcher("organizer-signup.jsp").forward(request, response);
            return;
        }
        
        // Hash password
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        
        // Create organizer
        Organizer organizer = new Organizer(name, email, hashedPassword, phone, companyName);
        organizer.setAddress(address);
        
        boolean success = organizerDao.registerOrganizer(organizer);
        
        if (success) {
            // Send email to admin about new organizer registration
            try {
                EmailUtil.sendOrganizerRequestToAdmin("reddycharlamahendra2428@gmail.com", name, email, companyName);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/organizer-login.jsp?success=Registration successful! Your account is pending approval by admin.");
        } else {
            request.setAttribute("error", "Registration failed! Please try again.");
            request.getRequestDispatcher("organizer-signup.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle organizer login
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required!");
            request.getRequestDispatcher("organizer-login.jsp").forward(request, response);
            return;
        }
        
        Organizer organizer = organizerDao.getOrganizerByEmail(email);
        
        if (organizer == null) {
            request.setAttribute("error", "Email not registered!");
            request.getRequestDispatcher("organizer-login.jsp").forward(request, response);
            return;
        }
        
        // Check if approved
        if (!"approved".equals(organizer.getStatus())) {
            request.setAttribute("error", "Your account is " + organizer.getStatus() + ". Please wait for admin approval.");
            request.getRequestDispatcher("organizer-login.jsp").forward(request, response);
            return;
        }
        
        // Verify password
        if (BCrypt.checkpw(password, organizer.getPassword())) {
            HttpSession session = request.getSession(true);
            session.setAttribute("organizerId", organizer.getId());
            session.setAttribute("organizerName", organizer.getName());
            session.setAttribute("organizerEmail", organizer.getEmail());
            session.setAttribute("organizerCompany", organizer.getCompanyName());
            
            response.sendRedirect(request.getContextPath() + "/OrganizerServlet?action=dashboard");
        } else {
            request.setAttribute("error", "Invalid password!");
            request.getRequestDispatcher("organizer-login.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle organizer logout
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/organizer-login.jsp");
    }
    
    /**
     * Handle GET requests - FIXED: Use getSession(true) to maintain session
     */
    private void handleGetRequest(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        
        // Use getSession(true) to maintain existing session
        HttpSession session = request.getSession(true);
        Integer organizerId = (Integer) session.getAttribute("organizerId");
        
        if (organizerId == null) {
            // No organizer logged in - redirect to login
            response.sendRedirect(request.getContextPath() + "/organizer-login.jsp");
            return;
        }
        
        switch (action) {
            case ACTION_DASHBOARD:
                showDashboard(request, response);
                break;
            case ACTION_VIEW_MY_EVENTS:
                showMyEvents(request, response);
                break;
            case ACTION_EDIT_EVENT:
                showEditEvent(request, response);
                break;
            default:
                showDashboard(request, response);
        }
    }
    
    /**
     * Show organizer dashboard
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        int organizerId = (Integer) session.getAttribute("organizerId");
        
        List<Event> events = eventDao.getEventsByOrganizer(organizerId);
        
        int totalEvents = events.size();
        int approvedEvents = (int) events.stream().filter(e -> "approved".equals(e.getStatus())).count();
        int pendingEvents = (int) events.stream().filter(e -> "pending".equals(e.getStatus())).count();
        
        request.setAttribute("totalEvents", totalEvents);
        request.setAttribute("approvedEvents", approvedEvents);
        request.setAttribute("pendingEvents", pendingEvents);
        request.setAttribute("events", events);
        
        // Get categories for event form
        List<Category> categories = categoryDao.getActiveCategories();
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/organizer/organizer-dashboard.jsp").forward(request, response);
    }
    
    /**
     * Show organizer's events
     */
    private void showMyEvents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        int organizerId = (Integer) session.getAttribute("organizerId");
        
        List<Event> events = eventDao.getEventsByOrganizer(organizerId);
        request.setAttribute("events", events);
        
        request.getRequestDispatcher("/organizer/my-events.jsp").forward(request, response);
    }
    
    /**
     * Show edit event form
     */
    private void showEditEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        int organizerId = (Integer) session.getAttribute("organizerId");
        
        int eventId = Integer.parseInt(request.getParameter("id"));
        Event event = eventDao.getEventById(eventId);
        
        // Security check: ensure the event belongs to this organizer
        if (event == null || event.getOrganizerId() != organizerId) {
            response.sendRedirect(request.getContextPath() + "/OrganizerServlet?action=viewMyEvents&error=Event not found or access denied!");
            return;
        }
        
        List<Category> categories = categoryDao.getActiveCategories();
        request.setAttribute("event", event);
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/organizer/edit-event.jsp").forward(request, response);
    }
    
    /**
     * Add new event
     */
    private void handleAddEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("organizerId") == null) {
            response.sendRedirect(request.getContextPath() + "/organizer-login.jsp");
            return;
        }
        
        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String location = request.getParameter("location");
            String city = request.getParameter("city");
            String venueName = request.getParameter("venueName");
            Date eventDate = Date.valueOf(request.getParameter("eventDate"));
            Time eventTime = Time.valueOf(request.getParameter("eventTime") + ":00");
            BigDecimal ticketPrice = new BigDecimal(request.getParameter("ticketPrice"));
            int totalSeats = Integer.parseInt(request.getParameter("totalSeats"));
            String posterUrl = request.getParameter("posterUrl");
            
            int organizerId = (Integer) session.getAttribute("organizerId");
            
            Event event = new Event(title, description, categoryId, organizerId, location, city, 
                                     venueName, eventDate, eventTime, ticketPrice, totalSeats);
            event.setPosterUrl(posterUrl);
            
            boolean success = eventDao.addEvent(event);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/OrganizerServlet?action=dashboard&success=Event added successfully! Pending approval.");
            } else {
                response.sendRedirect(request.getContextPath() + "/OrganizerServlet?action=dashboard&error=Failed to add event!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/OrganizerServlet?action=dashboard&error=Invalid input data!");
        }
    }
    
    /**
     * Update event
     */
    private void handleUpdateEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("organizerId") == null) {
            response.sendRedirect(request.getContextPath() + "/organizer-login.jsp");
            return;
        }
        
        try {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String location = request.getParameter("location");
            String city = request.getParameter("city");
            String venueName = request.getParameter("venueName");
            Date eventDate = Date.valueOf(request.getParameter("eventDate"));
            Time eventTime = Time.valueOf(request.getParameter("eventTime") + ":00");
            BigDecimal ticketPrice = new BigDecimal(request.getParameter("ticketPrice"));
            int totalSeats = Integer.parseInt(request.getParameter("totalSeats"));
            String posterUrl = request.getParameter("posterUrl");
            
            Event event = eventDao.getEventById(eventId);
            if (event != null) {
                event.setTitle(title);
                event.setDescription(description);
                event.setCategoryId(categoryId);
                event.setLocation(location);
                event.setCity(city);
                event.setVenueName(venueName);
                event.setEventDate(eventDate);
                event.setEventTime(eventTime);
                event.setTicketPrice(ticketPrice);
                event.setTotalSeats(totalSeats);
                event.setPosterUrl(posterUrl);
                
                boolean success = eventDao.updateEvent(event);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/OrganizerServlet?action=viewMyEvents&success=Event updated successfully!");
                } else {
                    response.sendRedirect(request.getContextPath() + "/OrganizerServlet?action=viewMyEvents&error=Failed to update event!");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/OrganizerServlet?action=viewMyEvents&error=Event not found!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/OrganizerServlet?action=viewMyEvents&error=Invalid input data!");
        }
    }
    
    /**
     * Delete event
     */
    private void handleDeleteEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("organizerId") == null) {
            response.sendRedirect(request.getContextPath() + "/organizer-login.jsp");
            return;
        }
        
        int eventId = Integer.parseInt(request.getParameter("id"));
        
        boolean success = eventDao.deleteEvent(eventId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/OrganizerServlet?action=viewMyEvents&success=Event deleted successfully!");
        } else {
            response.sendRedirect(request.getContextPath() + "/OrganizerServlet?action=viewMyEvents&error=Failed to delete event!");
        }
    }
}
