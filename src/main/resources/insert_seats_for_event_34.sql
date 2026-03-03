-- Insert seats for event ID 34 (India vs Australia - T20 Cricket Match)
-- 50 seats - 5 rows x 10 seats

USE eventhub_db;

-- Delete existing seats for this event if any
DELETE FROM event_seats WHERE event_id = 34;

-- Insert seats (5 rows A-E, 10 seats each)
INSERT INTO event_seats (event_id, seat_number, row_label, seat_column, status) VALUES
(34, 'A1', 'A', 1, 'AVAILABLE'),
(34, 'A2', 'A', 2, 'AVAILABLE'),
(34, 'A3', 'A', 3, 'AVAILABLE'),
(34, 'A4', 'A', 4, 'AVAILABLE'),
(34, 'A5', 'A', 5, 'AVAILABLE'),
(34, 'A6', 'A', 6, 'AVAILABLE'),
(34, 'A7', 'A', 7, 'AVAILABLE'),
(34, 'A8', 'A', 8, 'AVAILABLE'),
(34, 'A9', 'A', 9, 'AVAILABLE'),
(34, 'A10', 'A', 10, 'AVAILABLE'),
(34, 'B1', 'B', 1, 'AVAILABLE'),
(34, 'B2', 'B', 2, 'AVAILABLE'),
(34, 'B3', 'B', 3, 'AVAILABLE'),
(34, 'B4', 'B', 4, 'AVAILABLE'),
(34, 'B5', 'B', 5, 'AVAILABLE'),
(34, 'B6', 'B', 6, 'AVAILABLE'),
(34, 'B7', 'B', 7, 'AVAILABLE'),
(34, 'B8', 'B', 8, 'AVAILABLE'),
(34, 'B9', 'B', 9, 'AVAILABLE'),
(34, 'B10', 'B', 10, 'AVAILABLE'),
(34, 'C1', 'C', 1, 'AVAILABLE'),
(34, 'C2', 'C', 2, 'AVAILABLE'),
(34, 'C3', 'C', 3, 'AVAILABLE'),
(34, 'C4', 'C', 4, 'AVAILABLE'),
(34, 'C5', 'C', 5, 'AVAILABLE'),
(34, 'C6', 'C', 6, 'AVAILABLE'),
(34, 'C7', 'C', 7, 'AVAILABLE'),
(34, 'C8', 'C', 8, 'AVAILABLE'),
(34, 'C9', 'C', 9, 'AVAILABLE'),
(34, 'C10', 'C', 10, 'AVAILABLE'),
(34, 'D1', 'D', 1, 'AVAILABLE'),
(34, 'D2', 'D', 2, 'AVAILABLE'),
(34, 'D3', 'D', 3, 'AVAILABLE'),
(34, 'D4', 'D', 4, 'AVAILABLE'),
(34, 'D5', 'D', 5, 'AVAILABLE'),
(34, 'D6', 'D', 6, 'AVAILABLE'),
(34, 'D7', 'D', 7, 'AVAILABLE'),
(34, 'D8', 'D', 8, 'AVAILABLE'),
(34, 'D9', 'D', 9, 'AVAILABLE'),
(34, 'D10', 'D', 10, 'AVAILABLE'),
(34, 'E1', 'E', 1, 'AVAILABLE'),
(34, 'E2', 'E', 2, 'AVAILABLE'),
(34, 'E3', 'E', 3, 'AVAILABLE'),
(34, 'E4', 'E', 4, 'AVAILABLE'),
(34, 'E5', 'E', 5, 'AVAILABLE'),
(34, 'E6', 'E', 6, 'AVAILABLE'),
(34, 'E7', 'E', 7, 'AVAILABLE'),
(34, 'E8', 'E', 8, 'AVAILABLE'),
(34, 'E9', 'E', 9, 'AVAILABLE'),
(34, 'E10', 'E', 10, 'AVAILABLE');

-- Verify seats were created
SELECT * FROM event_seats WHERE event_id = 34;
