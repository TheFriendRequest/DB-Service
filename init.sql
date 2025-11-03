-- ==========================================================
-- Friend Request Project: Initialization Script (SCHEMA + SEED)
-- ==========================================================

CREATE DATABASE IF NOT EXISTS friend_request_db;
USE friend_request_db;

-- drop in correct dependency order
DROP TABLE IF EXISTS Friendships;
DROP TABLE IF EXISTS UserSchedule;
DROP TABLE IF EXISTS UserInterests;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Interests;
DROP TABLE IF EXISTS Users;

-- -------------------------
-- USERS
-- -------------------------
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    profile_picture VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
-- USER SCHEDULE
-- -------------------------
CREATE TABLE UserSchedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    type ENUM('class','event','personal') NOT NULL,
    title VARCHAR(200) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
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

-- -------------------------
-- EVENTS
-- -------------------------
CREATE TABLE Events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    location VARCHAR(150),
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    capacity INT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(user_id)
);

CREATE TABLE EventInterests (
    event_id INT NOT NULL,
    interest_id INT NOT NULL,
    PRIMARY KEY (event_id, interest_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id) ON DELETE CASCADE,
    FOREIGN KEY (interest_id) REFERENCES Interests(interest_id) ON DELETE CASCADE
);

-- ================================================
-- INSERT SEED DATA
-- ================================================

-- users
INSERT INTO Users (first_name, last_name, username, email, profile_picture, password_hash)
VALUES
('Alice', 'Green', 'aliceg', 'alice@columbia.edu', NULL, 'hash1'),
('Bob', 'Cohen', 'bobc', 'bob@columbia.edu', NULL, 'hash2'),
('Charlie', 'Kim', 'charliek', 'charlie@columbia.edu', NULL, 'hash3');

-- interests
INSERT INTO Interests (interest_name) VALUES
('Sports'), ('Music'), ('Cooking'), ('Reading'), ('Gaming');

-- user interests mapping
INSERT INTO UserInterests (user_id, interest_id) VALUES
(1,2), -- Alice -> Music
(1,3), -- Alice -> Cooking
(2,4), -- Bob -> Reading
(2,5), -- Bob -> Gaming
(3,1), -- Charlie -> Sports
(3,3); -- Charlie -> Cooking

-- schedules
INSERT INTO UserSchedule (user_id, start_time, end_time, type, title) VALUES
(1,'2025-10-20 17:00:00','2025-10-20 18:30:00','class','COMS 4705 Lecture'),
(2,'2025-10-21 19:00:00','2025-10-21 21:00:00','personal','Gaming night'),
(3,'2025-10-22 19:00:00','2025-10-22 20:30:00','class','Linear Algebra Lecture');

-- friendships
INSERT INTO Friendships (user_id_1,user_id_2,status) VALUES
(1,2,'accepted'),
(1,3,'pending');

-- events
INSERT INTO Events (title, description, location, start_time, end_time, capacity, created_by)
VALUES
('Study Group','Data Science HW meetup','Butler Library','2025-10-20 17:00:00','2025-10-20 19:00:00',10,1),
('Basketball Game','Pickup basketball','Dodge Gym','2025-10-22 19:00:00','2025-10-22 21:00:00',14,3);

-- event interests mapping
INSERT INTO EventInterests (event_id, interest_id) VALUES
(1, 4), -- Study Group about Reading
(1, 2), -- Study Group maybe with Music chill
(2, 1); -- Basketball Game -> Sports