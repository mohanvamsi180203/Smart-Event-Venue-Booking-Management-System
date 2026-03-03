# Smart EventHub - Implementation TODO

## Phase 1: Admin Dashboard Fixes
- [ ] 1. Fix AdminServlet - ensure all actions forward to correct JSP pages in admin folder
- [ ] 2. Fix Quick Actions links in admin-dashboard.jsp
- [ ] 3. Add missing admin JSP pages (organizers.jsp, events.jsp, categories.jsp, bookings.jsp)

## Phase 2: EventServlet Improvements
- [ ] 4. Add search functionality in EventServlet
- [ ] 5. Add combined filtering (category + city) in EventServlet
- [ ] 6. Fix filterByCategory and filterByCity methods
- [ ] 7. Add "myBookings" action

## Phase 3: Home Page Improvements
- [ ] 8. Add location selection dropdown on homepage
- [ ] 9. Update index.jsp to load events from database
- [ ] 10. Add category filtering on homepage
- [ ] 11. Make event cards clickable to event-details.jsp

## Phase 4: Booking Functionality
- [ ] 12. Update events-list.jsp with proper booking links
- [ ] 13. Create my-bookings.jsp page
- [ ] 14. Ensure booking stores data in bookings table

## Phase 5: Session & Security
- [ ] 15. Add session validation to all protected pages
- [ ] 16. Add role checks for admin, organizer, user dashboards
- [ ] 17. Fix user-login.jsp to be unified login page

## Phase 6: CSS Consolidation
- [ ] 18. Use styles.css as main CSS for all pages
- [ ] 19. Remove or merge admin-style.css and organizer-dashboard.css references
