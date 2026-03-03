-- =====================================================
-- Smart EventHub Management System - Database Schema
-- =====================================================

-- Create database (if not exists)
CREATE DATABASE IF NOT EXISTS eventhub_db;
USE eventhub_db;

-- =====================================================
-- Admin Table
-- =====================================================
CREATE TABLE IF NOT EXISTS admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    
    INDEX idx_username (username)
);

-- =====================================================
-- Categories Table
-- =====================================================
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(50),
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_name (name),
    INDEX idx_is_active (is_active)
);

-- =====================================================
-- Organizer Table
-- =====================================================
CREATE TABLE IF NOT EXISTS organizer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    company_name VARCHAR(100),
    address TEXT,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    is_verified TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    approved_by INT NULL,
    approved_at TIMESTAMP NULL,
    
    INDEX idx_email (email),
    INDEX idx_status (status),
    INDEX idx_is_verified (is_verified),
    
    FOREIGN KEY (approved_by) REFERENCES admin(id) ON DELETE SET NULL
);

-- =====================================================
-- Events Table
-- =====================================================
CREATE TABLE IF NOT EXISTS events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    category_id INT NOT NULL,
    organizer_id INT NOT NULL,
    location VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    venue_name VARCHAR(200),
    event_date DATE NOT NULL,
    event_time TIME NOT NULL,
    duration_hours DECIMAL(4,2),
    poster_url VARCHAR(500),
    ticket_price DECIMAL(10,2) DEFAULT 0,
    total_seats INT NOT NULL,
    available_seats INT NOT NULL,
    status ENUM('pending', 'approved', 'rejected', 'cancelled') DEFAULT 'pending',
    is_featured TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_title (title),
    INDEX idx_category_id (category_id),
    INDEX idx_organizer_id (organizer_id),
    INDEX idx_event_date (event_date),
    INDEX idx_city (city),
    INDEX idx_status (status),
    
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    FOREIGN KEY (organizer_id) REFERENCES organizer(id) ON DELETE CASCADE
);

-- =====================================================
-- Users Table (already exists, adding location column)
-- Note: These columns will be added only if they don't exist and if the table exists

-- =====================================================
-- Bookings Table
-- =====================================================
CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    booking_reference VARCHAR(20) NOT NULL UNIQUE,
    number_of_tickets INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    booking_status ENUM('pending', 'confirmed', 'cancelled', 'refunded') DEFAULT 'pending',
    payment_method VARCHAR(50),
    payment_status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
    payment_id VARCHAR(100),
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    event_date DATE,
    
    INDEX idx_booking_reference (booking_reference),
    INDEX idx_user_id (user_id),
    INDEX idx_event_id (event_id),
    INDEX idx_booking_status (booking_status),
    INDEX idx_event_date (event_date),
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);

-- =====================================================
-- Insert Default Admin (password: admin123)
-- =====================================================
INSERT INTO admin (username, password, email, full_name) 
VALUES ('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMye/U.N4.5F.HQW5R.HGmh3GJLd.0MvHGi', 'admin@eventhub.com', 'System Administrator')
ON DUPLICATE KEY UPDATE username = username;

-- =====================================================
-- Insert Default Categories
-- =====================================================
INSERT INTO categories (name, description, icon) VALUES
('Sports', 'Sports events including cricket, football, tennis and more', '🏟️'),
('Movies', 'Movie premieres, film festivals and cinema events', '🎬'),
('Tech', 'Technology conferences, hackathons and tech events', '💻'),
('Cultural', 'Cultural events, concerts, festivals and performances', '🎭'),
('Business', 'Business conferences, seminars and networking events', '💼'),
('Workshops', 'Educational workshops and training sessions', '🎓')
ON DUPLICATE KEY UPDATE name = name;

-- =====================================================
-- Display all tables
-- =====================================================
SHOW TABLES;

-- Verify table structures
DESCRIBE admin;
DESCRIBE organizer;
DESCRIBE categories;
DESCRIBE events;
DESCRIBE bookings;
