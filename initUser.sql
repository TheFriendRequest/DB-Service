-- ==========================================================
-- User Service Database: Initialization Script
-- ==========================================================
CREATE DATABASE IF NOT EXISTS user_db;
USE user_db;

-- Drop tables in correct dependency order
DROP TABLE IF EXISTS Friendships;
DROP TABLE IF EXISTS UserInterests;
DROP TABLE IF EXISTS Interests;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS UserSchedule;

-- -------------------------
-- USERS
-- -------------------------
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    firebase_uid VARCHAR(128) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    profile_picture VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------
-- USER SCHEDULE
-- -------------------------
CREATE TABLE UserSchedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,  -- References user_id from user_db
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    type ENUM('class','event','personal') NOT NULL,
    title VARCHAR(200) NOT NULL
    -- Note: No foreign key to Users table
);

-- -------------------------
-- INTERESTS (master)
-- -------------------------
CREATE TABLE Interests (
    interest_id INT AUTO_INCREMENT PRIMARY KEY,
    interest_name VARCHAR(100) UNIQUE NOT NULL
);

-- -------------------------
-- USER INTERESTS (mapping)
-- -------------------------
CREATE TABLE UserInterests (
    user_id INT NOT NULL,
    interest_id INT NOT NULL,
    PRIMARY KEY (user_id, interest_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (interest_id) REFERENCES Interests(interest_id) ON DELETE CASCADE
);

-- -------------------------
-- FRIENDSHIPS
-- -------------------------
CREATE TABLE Friendships (
    friendship_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id_1 INT NOT NULL,
    user_id_2 INT NOT NULL,
    status ENUM('pending','accepted') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id_1) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id_2) REFERENCES Users(user_id) ON DELETE CASCADE,
    UNIQUE KEY (user_id_1, user_id_2)
);

-- ================================================
-- INSERT SEED DATA
-- ================================================

-- Users (Note: firebase_uid is required - seed data uses placeholder values)
-- In production, these would be real Firebase UIDs from authentication
INSERT INTO Users (firebase_uid, first_name, last_name, username, email, profile_picture) VALUES
('firebase_uid_alice', 'Alice', 'Green', 'aliceg', 'alice@columbia.edu', NULL),
('firebase_uid_bob', 'Bob', 'Cohen', 'bobc', 'bob@columbia.edu', NULL),
('firebase_uid_charlie', 'Charlie', 'Kim', 'charliek', 'charlie@columbia.edu', NULL);

-- Interests
INSERT INTO Interests (interest_name) VALUES
('Sports'), ('Music'), ('Cooking'), ('Reading'), ('Gaming');

-- User schedules
INSERT INTO UserSchedule (user_id, start_time, end_time, type, title) VALUES
(1, '2025-10-20 17:00:00', '2025-10-20 18:30:00', 'class', 'COMS 4705 Lecture'),
(2, '2025-10-21 19:00:00', '2025-10-21 21:00:00', 'personal', 'Gaming night'),
(3, '2025-10-22 19:00:00', '2025-10-22 20:30:00', 'class', 'Linear Algebra Lecture');

-- User interests mapping
INSERT INTO UserInterests (user_id, interest_id) VALUES
(1,2), -- Alice -> Music
(1,3), -- Alice -> Cooking
(2,4), -- Bob -> Reading
(2,5), -- Bob -> Gaming
(3,1), -- Charlie -> Sports
(3,3); -- Charlie -> Cooking

-- Friendships
INSERT INTO Friendships (user_id_1, user_id_2, status) VALUES
(1,2,'accepted'),
(1,3,'pending');