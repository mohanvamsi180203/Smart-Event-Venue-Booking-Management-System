-- Database Schema for EventHub User Registration System
-- Run this script to create the required database and tables

-- Create database (if not exists)
CREATE DATABASE IF NOT EXISTS eventhub_db;

USE eventhub_db;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    otp INT DEFAULT 0,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_is_verified (is_verified)
);

-- Display table structure
DESCRIBE users;

-- Sample query to check users
SELECT id, name, email, is_verified, created_at FROM users;
