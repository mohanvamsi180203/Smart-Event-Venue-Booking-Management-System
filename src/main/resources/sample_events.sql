-- Sample Events Data for Smart EventHub
-- Run this script to add sample events

USE eventhub_db;

-- Insert sample events using the correct organizer_id=4 and category IDs 1-5
INSERT INTO events (title, description, category_id, organizer_id, location, city, venue_name, event_date, event_time, duration_hours, poster_url, ticket_price, total_seats, available_seats, status, is_featured) VALUES
('India vs Australia - T20 Cricket Match', 'Exciting T20 cricket match between India and Australia at Wankhede Stadium. Dont miss the action!', 1, 4, 'Wankhede Stadium, Mumbai', 'Mumbai', 'Wankhede Stadium', '2025-02-15', '19:30:00', 4.00, 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400', 2500.00, 500, 500, 'approved', 1),
('Premier League Football Watch Party', 'Watch the premier league match live on big screens with fellow fans. Food and beverages available.', 1, 4, 'Indoor Sports Arena', 'Delhi', 'Sports Bar & Grill', '2025-02-20', '21:00:00', 3.00, NULL, 500.00, 200, 200, 'approved', 0),
('Hollywood Blockbuster Premiere', 'Exclusive premiere of the latest Hollywood action movie. Red carpet event with star cast.', 2, 4, 'PVR Cinemas, Bangalore', 'Bangalore', 'PVR Gold Class', '2025-02-10', '18:00:00', 2.30, 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400', 800.00, 300, 300, 'approved', 1),
('International Film Festival', 'Annual international film festival featuring award-winning movies from around the world.', 2, 4, 'inox Cinemas', 'Chennai', 'Inox Leisure', '2025-02-25', '10:00:00', 8.00, NULL, 1500.00, 150, 150, 'approved', 0),
('TechCrunch Disrupt India', 'India''s premier technology conference featuring startups, investors, and tech leaders.', 3, 4, 'Bengaluru International Exhibition Centre', 'Bangalore', 'BIEC Main Hall', '2025-03-01', '09:00:00', 10.00, 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400', 5000.00, 1000, 1000, 'approved', 1),
('AI & Machine Learning Workshop', 'Hands-on workshop on Artificial Intelligence and Machine Learning fundamentals.', 3, 4, 'Tech Park Hyderabad', 'Hyderabad', 'Innovation Hub', '2025-02-28', '10:00:00', 6.00, NULL, 2500.00, 50, 50, 'approved', 0),
('AR Rahman Live Concert', 'Legendary composer AR Rahman live in concert with his orchestra. A musical experience of a lifetime!', 4, 4, 'Jawaharlal Nehru Stadium', 'Delhi', 'JN Stadium', '2025-03-10', '19:00:00', 3.30, 'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?w=400', 3500.00, 5000, 5000, 'approved', 1),
('Classical Dance Festival', 'Traditional Indian classical dance performances featuring renowned artists.', 4, 4, 'Narayana Sangeeth Sabha', 'Chennai', 'NSS Hall', '2025-02-18', '18:00:00', 3.00, NULL, 1200.00, 400, 400, 'approved', 0),
('Startup India Summit 2025', 'India''s biggest startup conference with keynote speeches, panel discussions, and networking.', 5, 4, 'Mumbai Convention Centre', 'Mumbai', 'MCC Main Auditorium', '2025-03-05', '09:30:00', 8.00, 'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=400', 7500.00, 800, 800, 'approved', 1),
('Business Leadership Forum', 'Network with industry leaders and learn about the latest business trends.', 5, 4, 'Hotel Taj Lands End', 'Mumbai', 'Ballroom', '2025-02-22', '14:00:00', 4.00, NULL, 3000.00, 200, 200, 'approved', 0),
('Cricket - IPL Match', 'Watch live IPL cricket action at the stadium. Cheer for your favorite team!', 1, 4, 'M. Chinnaswamy Stadium', 'Bangalore', 'M Chinnaswamy Stadium', '2025-04-05', '20:00:00', 4.00, 'https://images.unsplash.com/photo-1563114773-84221bd62daa?w=400', 3000.00, 1000, 1000, 'approved', 1),
('Marathon 2025', 'Annual city marathon. Participate or come cheer the runners!', 1, 4, 'Marine Drive', 'Mumbai', 'Start Line: Marine Drive', '2025-02-28', '05:00:00', 5.00, NULL, 500.00, 5000, 5000, 'approved', 0),
('Comedy Night Live', 'Stand-up comedy show featuring top comedians. Laugh out loud!', 4, 4, 'The Comedy Store', 'Mumbai', 'Comedy Store Mumbai', '2025-02-14', '20:00:00', 2.30, NULL, 1500.00, 150, 150, 'approved', 0),
('Ed Sheeran Live Concert', 'Global music sensation Ed Sheeran performs his greatest hits live in Mumbai!', 4, 4, 'DY Patil Stadium', 'Mumbai', 'DY Patil Stadium', '2025-03-15', '19:00:00', 3.00, 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=400', 5000.00, 5000, 5000, 'approved', 1),
('NBA Basketball Game', 'Experience the thrill of NBA basketball live. Watch your favorite teams compete!', 1, 4, 'Sardar Patel Stadium', 'Ahmedabad', 'Sports Complex', '2025-03-20', '18:00:00', 2.30, 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400', 3500.00, 1500, 1500, 'approved', 1),
('Bollywood Music Awards', 'India''s biggest Bollywood music awards ceremony featuring top singers and actors.', 4, 4, 'NRG Stadium', 'Hyderabad', 'Hyderabad Convention Center', '2025-03-25', '20:00:00', 3.00, NULL, 4000.00, 2000, 2000, 'approved', 1),
('World Cup Cricket Final', 'The biggest cricket match of the year! Watch the world cup final live.', 1, 4, 'Narayana Stadium', 'Kolkata', 'Eden Gardens', '2025-04-10', '14:00:00', 8.00, 'https://images.unsplash.com/photo-1563114773-84221bd62daa?w=400', 10000.00, 2000, 2000, 'approved', 1),
('International Food Festival', 'Taste cuisines from around the world at this grand food festival.', 5, 4, 'Trade Center', 'Delhi', 'Delhi Expo Center', '2025-03-08', '11:00:00', 8.00, 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400', 800.00, 500, 500, 'approved', 1),
('DJ Night Party', 'Dance the night away with top international DJs spinning the latest tracks!', 4, 4, 'Club Marina', 'Goa', 'Club Marina Beach', '2025-03-12', '22:00:00', 5.00, NULL, 2000.00, 300, 300, 'approved', 0),
('Tennis Open India', 'International tennis championship featuring top players from around the world.', 1, 4, 'SDAT Stadium', 'Chennai', 'Chennai Tennis Stadium', '2025-03-18', '10:00:00', 6.00, NULL, 2000.00, 800, 800, 'approved', 1);

-- Verify the events
SELECT e.id, e.title, e.city, e.status, c.name as category 
FROM events e 
LEFT JOIN categories c ON e.category_id = c.id 
WHERE e.status = 'approved';
