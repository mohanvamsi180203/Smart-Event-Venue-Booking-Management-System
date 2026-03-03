-- Fix Category Icons - Run this SQL to fix corrupted emoji characters
-- Run this in MySQL Workbench or command line

USE eventhub_db;

UPDATE categories SET icon = '🏟️' WHERE name = 'Sports';
UPDATE categories SET icon = '🎬' WHERE name = 'Movies';
UPDATE categories SET icon = '💻' WHERE name = 'Tech';
UPDATE categories SET icon = '🎭' WHERE name = 'Cultural';
UPDATE categories SET icon = '💼' WHERE name = 'Business';
UPDATE categories SET icon = '🎓' WHERE name = 'Workshops';

-- Verify the fix
SELECT id, name, icon, description FROM categories;
