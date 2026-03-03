# TODO - Dynamic Section-Based Seat Layout System

## Task: Implement dynamic seat layout where organizers define sections with rows, seats per row, and pricing

### Steps:
- [x] 1. Create Section.java DTO class
- [x] 2. Create SectionDao.java for CRUD operations and seat generation
- [x] 3. Update schema.sql with sections table
- [x] 4. Update Event.java DTO to include List<Section>
- [x] 5. Update Seat.java to include sectionId and sectionName
- [x] 6. Update OrganizerServlet.java to handle section data
- [x] 7. Update seat_booking_schema.sql to add section_id column
- [ ] 8. Update organizer dashboard JSP with dynamic section form (UI)

### How it works:
1. Organizer creates event with sections (each section has: name, rows, seats per row, price)
2. Backend saves sections to database
3. Backend automatically generates seats based on section configuration
4. Users can then book individual seats from the generated seat map

