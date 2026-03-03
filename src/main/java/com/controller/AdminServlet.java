package com.controller;

import java.io.IOException;
import java.util.List;

import com.dao.AdminDao;
import com.dao.BookingDao;
import com.dao.CategoryDao;
import com.dao.EventDao;
import com.dao.OrganizerDao;
import com.dto.Admin;
import com.dto.Booking;
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
 * Admin Servlet - Handles all admin operations
 */
@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private AdminDao adminDao;
    private OrganizerDao organizerDao;
    private EventDao eventDao;
    private CategoryDao categoryDao;
    private BookingDao bookingDao;
    
    // Action constants
    private static final String ACTION_LOGIN = "login";
    private static final String ACTION_LOGOUT = "logout";
    private static final String ACTION_DASHBOARD = "dashboard";
    private static final String ACTION_VIEW_ORGANIZERS = "viewOrganizers";
    private static final String ACTION_APPROVE_ORGANIZER = "approveOrganizer";
    private static final String ACTION_REJECT_ORGANIZER = "rejectOrganizer";
    private static final String ACTION_VIEW_EVENTS = "viewEvents";
    private static final String ACTION_APPROVE_EVENT = "approveEvent";
    private static final String ACTION_REJECT_EVENT = "rejectEvent";
    private static final String ACTION_VIEW_CATEGORIES = "viewCategories";
    private static final String ACTION_ADD_CATEGORY = "addCategory";
    private static final String ACTION_UPDATE_CATEGORY = "updateCategory";
    private static final String ACTION_DELETE_CATEGORY = "deleteCategory";
    private static final String ACTION_VIEW_BOOKINGS = "viewBookings";
    
    @Override
    public void init() throws ServletException {
        adminDao = new AdminDao();
        organizerDao = new OrganizerDao();
        eventDao = new EventDao();
        categoryDao = new CategoryDao();
        bookingDao = new BookingDao();
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
            case ACTION_APPROVE_ORGANIZER:
                handleApproveOrganizer(request, response);
                break;
            case ACTION_REJECT_ORGANIZER:
                handleRejectOrganizer(request, response);
                break;
            case ACTION_APPROVE_EVENT:
                handleApproveEvent(request, response);
                break;
            case ACTION_REJECT_EVENT:
                handleRejectEvent(request, response);
                break;
            case ACTION_DASHBOARD:
            case ACTION_VIEW_ORGANIZERS:
            case ACTION_VIEW_EVENTS:
            case ACTION_VIEW_CATEGORIES:
            case ACTION_VIEW_BOOKINGS:
                handleGetRequest(request, response, action);
                break;
            default:
                response.sendRedirect("admin-login.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }
        
        switch (action) {
            case ACTION_LOGIN:
                handleLogin(request, response);
                break;
            case ACTION_APPROVE_ORGANIZER:
                handleApproveOrganizer(request, response);
                break;
            case ACTION_REJECT_ORGANIZER:
                handleRejectOrganizer(request, response);
                break;
            case ACTION_APPROVE_EVENT:
                handleApproveEvent(request, response);
                break;
            case ACTION_REJECT_EVENT:
                handleRejectEvent(request, response);
                break;
            case ACTION_ADD_CATEGORY:
                handleAddCategory(request, response);
                break;
            case ACTION_UPDATE_CATEGORY:
                handleUpdateCategory(request, response);
                break;
            case ACTION_DELETE_CATEGORY:
                handleDeleteCategory(request, response);
                break;
            default:
                response.sendRedirect("admin-login.jsp");
        }
    }
    
    /**
     * Handle admin login
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required!");
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
            return;
        }
        
        Admin admin = adminDao.login(username, password);
        
        if (admin != null) {
            // Login successful
            HttpSession session = request.getSession();
            session.setAttribute("adminId", admin.getId());
            session.setAttribute("adminUsername", admin.getUsername());
            session.setAttribute("adminEmail", admin.getEmail());
            session.setAttribute("adminFullName", admin.getFullName());
            
            // Update last login
            adminDao.updateLastLogin(admin.getId());
            
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=dashboard");
        } else {
            request.setAttribute("error", "Invalid username or password!");
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle admin logout
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
    }
    
    /**
     * Handle GET requests
     */
    private void handleGetRequest(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }
        
        switch (action) {
            case ACTION_DASHBOARD:
                showDashboard(request, response);
                break;
            case ACTION_VIEW_ORGANIZERS:
                showOrganizers(request, response);
                break;
            case ACTION_VIEW_EVENTS:
                showEvents(request, response);
                break;
            case ACTION_VIEW_CATEGORIES:
                showCategories(request, response);
                break;
            case ACTION_VIEW_BOOKINGS:
                showBookings(request, response);
                break;
            default:
                showDashboard(request, response);
        }
    }
    
    /**
     * Show admin dashboard
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get statistics
        int totalEvents = eventDao.getTotalEventsCount();
        int approvedEvents = eventDao.getApprovedEventsCount();
        int pendingEvents = eventDao.getPendingEventsCount();
        int pendingOrganizers = organizerDao.getPendingCount();
        int approvedOrganizers = organizerDao.getApprovedCount();
        int totalBookings = bookingDao.getTotalBookingsCount();
        double totalRevenue = bookingDao.getTotalRevenue();
        
        request.setAttribute("totalEvents", totalEvents);
        request.setAttribute("approvedEvents", approvedEvents);
        request.setAttribute("pendingEvents", pendingEvents);
        request.setAttribute("pendingOrganizers", pendingOrganizers);
        request.setAttribute("approvedOrganizers", approvedOrganizers);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalRevenue", totalRevenue);
        
        request.getRequestDispatcher("/admin/admin-dashboard.jsp").forward(request, response);
    }
    
    /**
     * Show all organizers
     */
    private void showOrganizers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String status = request.getParameter("status");
        List<Organizer> organizers;
        
        if (status != null && !status.isEmpty()) {
            organizers = organizerDao.getOrganizersByStatus(status);
        } else {
            organizers = organizerDao.getAllOrganizers();
        }
        
        request.setAttribute("organizers", organizers);
        request.setAttribute("status", status);
        request.getRequestDispatcher("/admin/organizers.jsp").forward(request, response);
    }
    
    /**
     * Approve organizer
     */
    private void handleApproveOrganizer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }
        
        int organizerId = Integer.parseInt(request.getParameter("id"));
        int adminId = (Integer) session.getAttribute("adminId");
        
        boolean success = organizerDao.updateStatus(organizerId, "approved", adminId);
        
        if (success) {
            // Send approval email to organizer
            try {
                Organizer organizer = organizerDao.getOrganizerById(organizerId);
                if (organizer != null) {
                    EmailUtil.sendOrganizerApprovalSuccess(organizer.getEmail(), organizer.getName());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewOrganizers&success=Organizer approved successfully!");
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewOrganizers&error=Failed to approve organizer!");
        }
    }
    
    /**
     * Reject organizer
     */
    private void handleRejectOrganizer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }
        
        int organizerId = Integer.parseInt(request.getParameter("id"));
        int adminId = (Integer) session.getAttribute("adminId");
        
        boolean success = organizerDao.updateStatus(organizerId, "rejected", adminId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewOrganizers&success=Organizer rejected!");
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewOrganizers&error=Failed to reject organizer!");
        }
    }
    
    /**
     * Show all events
     */
    private void showEvents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String status = request.getParameter("status");
        List<Event> events;
        
        if (status != null && !status.isEmpty()) {
            events = eventDao.getPendingEvents();
            // Filter by status
            events = events.stream()
                .filter(e -> e.getStatus().equals(status))
                .collect(java.util.stream.Collectors.toList());
        } else {
            events = eventDao.getAllEvents();
        }
        
        request.setAttribute("events", events);
        request.setAttribute("status", status);
        request.getRequestDispatcher("/admin/events.jsp").forward(request, response);
    }
    
    /**
     * Approve event
     */
    private void handleApproveEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }
        
        int eventId = Integer.parseInt(request.getParameter("id"));
        
        boolean success = eventDao.updateStatus(eventId, "approved");
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewEvents&success=Event approved successfully!");
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewEvents&error=Failed to approve event!");
        }
    }
    
    /**
     * Reject event
     */
    private void handleRejectEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }
        
        int eventId = Integer.parseInt(request.getParameter("id"));
        
        boolean success = eventDao.updateStatus(eventId, "rejected");
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewEvents&success=Event rejected!");
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewEvents&error=Failed to reject event!");
        }
    }
    
    /**
     * Show all categories
     */
    private void showCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Category> categories = categoryDao.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
    }
    
    /**
     * Add new category
     */
    private void handleAddCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }
        
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String icon = request.getParameter("icon");
        
        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewCategories&error=Category name is required!");
            return;
        }
        
        Category category = new Category(name, description, icon);
        boolean success = categoryDao.addCategory(category);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewCategories&success=Category added successfully!");
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewCategories&error=Failed to add category!");
        }
    }
    
    /**
     * Update category
     */
    private void handleUpdateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String icon = request.getParameter("icon");
        String isActive = request.getParameter("isActive");
        
        Category category = categoryDao.getCategoryById(id);
        if (category != null) {
            category.setName(name);
            category.setDescription(description);
            category.setIcon(icon);
            category.setActive("on".equals(isActive));
            
            boolean success = categoryDao.updateCategory(category);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewCategories&success=Category updated successfully!");
            } else {
                response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewCategories&error=Failed to update category!");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewCategories&error=Category not found!");
        }
    }
    
    /**
     * Delete category
     */
    private void handleDeleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        boolean success = categoryDao.deleteCategory(id);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewCategories&success=Category deleted successfully!");
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=viewCategories&error=Failed to delete category!");
        }
    }
    
    /**
     * Show all bookings
     */
    private void showBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Booking> bookings = bookingDao.getAllBookings();
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/admin/bookings.jsp").forward(request, response);
    }
}
