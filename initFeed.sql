-- ==========================================================
-- Feed Service Database: Initialization Script
-- ==========================================================
CREATE DATABASE IF NOT EXISTS feed_db;
USE feed_db;

-- Drop tables in correct dependency order
DROP TABLE IF EXISTS PostInterests;
DROP TABLE IF EXISTS Posts;
DROP TABLE IF EXISTS Interests;

-- -------------------------
-- INTERESTS (copied per-service for independence)
-- -------------------------
CREATE TABLE Interests (
    interest_id INT AUTO_INCREMENT PRIMARY KEY,
    interest_name VARCHAR(100) UNIQUE NOT NULL
);

-- -------------------------
-- POSTS
-- -------------------------
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    body TEXT,
    image_url VARCHAR(255),
    created_by INT,      -- Refers to user_id in user_db (handled externally)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    -- No FK constraint to Users table because it's in another DB
);

-- -------------------------
-- POST INTERESTS (mapping)
-- -------------------------
CREATE TABLE PostInterests (
    post_id INT NOT NULL,
    interest_id INT NOT NULL,
    PRIMARY KEY (post_id, interest_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (interest_id) REFERENCES Interests(interest_id) ON DELETE CASCADE
);

-- ==========================================================
-- INSERT SEED DATA
-- ==========================================================

-- Interests
INSERT INTO Interests (interest_name) VALUES
('Sports'), ('Music'), ('Cooking'), ('Reading'), ('Gaming');

-- Posts
INSERT INTO Posts (title, body, image_url, created_by) VALUES
('Best Gaming Laptop of 2025', 'Here is a breakdown of top gaming laptops…', NULL, 2),
('Healthy Cooking Tips', 'Simple recipes for clean eating!', NULL, 1),
('Classical Music Thoughts', 'Why classical structures are magical.', NULL, 4);

-- Post-interest mapping
INSERT INTO PostInterests (post_id, interest_id) VALUES
(1, 5), -- gaming laptop -> Gaming
(2, 3), -- cooking tips -> Cooking
(3, 2); -- classical music -> Music
