# TODO.md - Project Tasks

## Phase 1: Admin Dashboard Fixes (COMPLETED)
- [x] Fix AdminServlet to forward to correct admin JSP pages in admin folder
- [x] Add missing admin JSP pages (organizers.jsp, events.jsp, categories.jsp, bookings.jsp)
- [x] Fix Quick Actions links in admin-dashboard.jsp
- [x] Database schema - ensure all tables are created

## Phase 2: Event Filtering (COMPLETED)
- [x] Add search and combined filtering (category + city) in EventServlet
- [x] Add getEventsByCategoryAndCity() to EventDao
- [x] Add getUniqueCities() to EventDao
- [x] Update events-list.jsp to call correct servlet actions

## Phase 3: User Module (COMPLETED)
- [x] Add "myBookings" action to EventServlet
- [x] Create my-bookings.jsp for users
- [x] Make event cards clickable on homepage
- [x] Add location selection dropdown on homepage
- [x] Add category-based filtering on homepage
- [x] Event details page with booking functionality

## Phase 4: Session-based Authentication (COMPLETED)
- [x] Add session validation to all protected pages
- [x] Add role checks for admin, organizer, and user dashboards

## Testing Notes
- Admin credentials: username=admin, password=admin123
- Database needs categories and events to be populated
- Server runs on port 9090 (not 8080)
