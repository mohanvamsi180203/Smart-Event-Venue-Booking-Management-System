-- Seat Booking System Database Schema
-- Run this script to add seat management to your database

USE eventhub_db;

-- 1. Create event_seats table for individual seat control
CREATE TABLE IF NOT EXISTS event_seats (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    row_label VARCHAR(5) NOT NULL,
    seat_column INT NOT NULL,
    status ENUM('AVAILABLE', 'LOCKED', 'BOOKED') DEFAULT 'AVAILABLE',
    locked_by INT DEFAULT NULL,
    lock_time TIMESTAMP NULL DEFAULT NULL,
    booking_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (locked_by) REFERENCES users(id) ON DELETE SET NULL,
    UNIQUE KEY unique_event_seat (event_id, seat_number)
);

-- 2. Create booking_seats table for many-to-many relationship
CREATE TABLE IF NOT EXISTS booking_seats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    seat_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES event_seats(seat_id) ON DELETE CASCADE
);

-- 3. Update bookings table to add payment_status if not exists
-- This is optional - check your existing bookings table structure

-- 4. Procedure to generate seats for an event
DELIMITER //
CREATE PROCEDURE generate_event_seats(
    IN p_event_id INT,
    IN p_total_seats INT,
    IN p_rows INT,
    IN p_seats_per_row INT
)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE row_num INT DEFAULT 1;
    DECLARE seat_num INT DEFAULT 1;
    DECLARE seat_char CHAR(1);
    DECLARE seat_label VARCHAR(10);
    
    -- Clear existing seats for this event
    DELETE FROM event_seats WHERE event_id = p_event_id;
    
    -- Generate new seats
    WHILE row_num <= p_rows DO
        SET seat_num = 1;
        WHILE seat_num <= p_seats_per_row DO
            -- Convert row number to letter (1=A, 2=B, etc.)
            SET seat_char = CHAR(64 + row_num);
            SET seat_label = CONCAT(seat_char, seat_num);
            
            INSERT INTO event_seats (event_id, seat_number, row_label, seat_column, status)
            VALUES (p_event_id, seat_label, seat_char, seat_num, 'AVAILABLE');
            
            SET seat_num = seat_num + 1;
        END WHILE;
        SET row_num = row_num + 1;
    END WHILE;
END //
DELIMITER ;

-- 5. Procedure to lock seats for a user
DELIMITER //
CREATE PROCEDURE lock_seats(
    IN p_event_id INT,
    IN p_seat_numbers VARCHAR(500),
    IN p_user_id INT
)
BEGIN
    DECLARE seat_number VARCHAR(10);
    DECLARE remaining_seats VARCHAR(500);
    DECLARE comma_pos INT;
    
    SET remaining_seats = p_seat_numbers;
    
    WHILE LENGTH(remaining_seats) > 0 DO
        SET comma_pos = LOCATE(',', remaining_seats);
        
        IF comma_pos > 0 THEN
            SET seat_number = TRIM(SUBSTRING(remaining_seats, 1, comma_pos - 1));
            SET remaining_seats = TRIM(SUBSTRING(remaining_seats, comma_pos + 1));
        ELSE
            SET seat_number = TRIM(remaining_seats);
            SET remaining_seats = '';
        END IF;
        
        -- Only lock if seat is available and not locked by another user
        UPDATE event_seats 
        SET status = 'LOCKED', 
            locked_by = p_user_id, 
            lock_time = NOW() 
        WHERE event_id = p_event_id 
        AND seat_number = seat_number 
        AND status = 'AVAILABLE';
    END WHILE;
END //
DELIMITER ;

-- 6. Procedure to release expired locks (call this periodically)
DELIMITER //
CREATE PROCEDURE release_expired_locks()
BEGIN
    UPDATE event_seats 
    SET status = 'AVAILABLE', 
        locked_by = NULL, 
        lock_time = NULL 
    WHERE status = 'LOCKED' 
    AND lock_time < DATE_SUB(NOW(), INTERVAL 5 MINUTE);
END //
DELIMITER ;

-- 7. Procedure to book locked seats
DELIMITER //
CREATE PROCEDURE book_seats(
    IN p_booking_id INT,
    IN p_event_id INT,
    IN p_seat_numbers VARCHAR(500),
    IN p_user_id INT
)
BEGIN
    DECLARE seat_number VARCHAR(10);
    DECLARE remaining_seats VARCHAR(500);
    DECLARE comma_pos INT;
    DECLARE seat_id INT;
    
    SET remaining_seats = p_seat_numbers;
    
    WHILE LENGTH(remaining_seats) > 0 DO
        SET comma_pos = LOCATE(',', remaining_seats);
        
        IF comma_pos > 0 THEN
            SET seat_number = TRIM(SUBSTRING(remaining_seats, 1, comma_pos - 1));
            SET remaining_seats = TRIM(SUBSTRING(remaining_seats, comma_pos + 1));
        ELSE
            SET seat_number = TRIM(remaining_seats);
            SET remaining_seats = '';
        END IF;
        
        -- Get seat_id and update status
        SELECT seat_id INTO seat_id FROM event_seats 
        WHERE event_id = p_event_id AND seat_number = seat_number 
        AND locked_by = p_user_id AND status = 'LOCKED';
        
        IF seat_id IS NOT NULL THEN
            UPDATE event_seats 
            SET status = 'BOOKED', 
                booking_id = p_booking_id, 
                lock_time = NULL 
            WHERE seat_id = seat_id;
            
            -- Insert into booking_seats
            INSERT INTO booking_seats (booking_id, seat_id, seat_number, price)
            SELECT p_booking_id, seat_id, seat_number, ticket_price 
            FROM events WHERE id = p_event_id;
        END IF;
        
        SET seat_id = NULL;
    END WHILE;
END //
DELIMITER ;

-- 8. Sample: Generate seats for existing events
-- Run this to generate seats for your existing events
-- Replace 1 with your event IDs
CALL generate_event_seats(1, 100, 10, 10);
CALL generate_event_seats(2, 50, 5, 10);

-- Verify seats created
SELECT * FROM event_seats LIMIT 20;
