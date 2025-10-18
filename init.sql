-- ==========================================================
-- Friend Request Project: Initialization Script
-- This script is self-contained — it will create and use
-- a local database named `friend_request_db` automatically.
-- ==========================================================

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS friend_request_db;

-- Use the database
USE friend_request_db;

-- Drop existing tables safely (in dependency order)
DROP TABLE IF EXISTS EventParticipants;
DROP TABLE IF EXISTS UserInterests;
DROP TABLE IF EXISTS Messages;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Interests;
DROP TABLE IF EXISTS Users;

-- -------------------------
-- USERS
-- -------------------------
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    hobbies TEXT,
    free_time TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Users (name, email, password_hash, hobbies, free_time) VALUES
('Alice Green', 'alice@columbia.edu', 'hash1', 'hiking, music', 'weekends'),
('Bob Cohen', 'bob@columbia.edu', 'hash2', 'gaming, reading', 'evenings'),
('Charlie Kim', 'charlie@columbia.edu', 'hash3', 'basketball, cooking', 'mornings');

-- -------------------------
-- INTERESTS
-- -------------------------
CREATE TABLE Interests (
    interest_id INT AUTO_INCREMENT PRIMARY KEY,
    interest_name VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO Interests (interest_name) VALUES
('Sports'), ('Music'), ('Cooking'), ('Reading'), ('Gaming');

-- -------------------------
-- USER INTERESTS
-- -------------------------
CREATE TABLE UserInterests (
    user_id INT,
    interest_id INT,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, interest_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (interest_id) REFERENCES Interests(interest_id) ON DELETE CASCADE
);

INSERT INTO UserInterests (user_id, interest_id) VALUES
(1, 2), -- Alice -> Music
(1, 3), -- Alice -> Cooking
(2, 4), -- Bob -> Reading
(2, 5), -- Bob -> Gaming
(3, 1), -- Charlie -> Sports
(3, 3); -- Charlie -> Cooking

-- -------------------------
-- EVENTS
-- -------------------------
CREATE TABLE Events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    location VARCHAR(150),
    event_time DATETIME,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(user_id)
);

INSERT INTO Events (title, description, location, event_time, created_by) VALUES
('Study Group', 'Data Science HW meetup', 'Butler Library', '2025-10-20 17:00:00', 1),
('Basketball Game', 'Pickup basketball on campus', 'Dodge Gym', '2025-10-22 19:00:00', 3),
('Music Jam', 'Open mic night', 'Lerner Hall', '2025-10-24 20:00:00', 2);

-- -------------------------
-- EVENT PARTICIPANTS
-- -------------------------
CREATE TABLE EventParticipants (
    event_id INT,
    user_id INT,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (event_id, user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

INSERT INTO EventParticipants (event_id, user_id) VALUES
(1, 1), (1, 2),
(2, 3),
(3, 1), (3, 3);

-- -------------------------
-- MESSAGES
-- -------------------------
CREATE TABLE Messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    content TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES Users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES Users(user_id)
);

INSERT INTO Messages (sender_id, receiver_id, content) VALUES
(1, 2, 'Hey Bob, want to join the study group?'),
(2, 1, 'Sure, what time?'),
(3, 1, 'See you at basketball tonight!');

-- ==========================================================
-- ✅ Database successfully initialized.
-- ==========================================================
SELECT 'Database friend_request_db initialized successfully!' AS message;