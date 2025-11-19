-- ==========================================================
-- Event Service Database: Initialization Script
-- ==========================================================
CREATE DATABASE IF NOT EXISTS event_db;
USE event_db;

-- Drop tables in correct dependency order
DROP TABLE IF EXISTS EventInterests;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Interests;

-- -------------------------
-- INTERESTS (master - duplicated for event service independence)
-- -------------------------
CREATE TABLE Interests (
    interest_id INT AUTO_INCREMENT PRIMARY KEY,
    interest_name VARCHAR(100) UNIQUE NOT NULL
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
    created_by INT,  -- References user_id from user_db (handled at application level)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    -- Note: No foreign key to Users table since it's in another database
);

-- -------------------------
-- EVENT INTERESTS (mapping)
-- -------------------------
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

-- Interests (duplicated for event service independence)
INSERT INTO Interests (interest_name) VALUES
('Sports'), ('Music'), ('Cooking'), ('Reading'), ('Gaming');

-- Events
INSERT INTO Events (title, description, location, start_time, end_time, capacity, created_by) VALUES
('Study Group', 'Data Science HW meetup', 'Butler Library', '2025-10-20 17:00:00', '2025-10-20 19:00:00', 10, 1),
('Basketball Game', 'Pickup basketball', 'Dodge Gym', '2025-10-22 19:00:00', '2025-10-22 21:00:00', 14, 3);

-- Event interests mapping
INSERT INTO EventInterests (event_id, interest_id) VALUES
(1, 4), -- Study Group about Reading
(1, 2), -- Study Group maybe with Music chill
(2, 1); -- Basketball Game -> Sports