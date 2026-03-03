-- Simple way to add seats for events
-- Run this to insert seats directly

USE eventhub_db;

-- First check what events exist
SELECT id, title FROM events;

-- Then insert seats for each event manually
-- Example for event ID X (replace X with your actual event ID):
-- INSERT INTO event_seats (event_id, seat_number, row_label, seat_column, status)
-- VALUES 
-- (X, 'A1', 'A', 1, 'AVAILABLE'),
-- (X, 'A2', 'A', 2, 'AVAILABLE'),
-- (X, 'A3', 'A', 3, 'AVAILABLE'),
-- (X, 'A4', 'A', 4, 'AVAILABLE'),
-- (X, 'A5', 'A', 5, 'AVAILABLE'),
-- (X, 'B1', 'B', 1, 'AVAILABLE'),
-- (X, 'B2', 'B', 2, 'AVAILABLE'),
-- (X, 'B3', 'B', 3, 'AVAILABLE'),
-- (X, 'B4', 'B', 4, 'AVAILABLE'),
-- (X, 'B5', 'B', 5, 'AVAILABLE');

-- Let me check events and create seats dynamically
SELECT id, title, total_seats FROM events;
