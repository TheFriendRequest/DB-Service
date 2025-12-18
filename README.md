# Database Service

SQL initialization scripts and database schema definitions for all microservices.

## 📋 Overview

This directory contains SQL scripts to initialize and set up databases for:
- **Users Service** - User management database
- **Event Service** - Event management database
- **Feed Service** - Post and feed database

## 🗄️ Database Schemas

### User Database (`user_db`)

**File**: `initUser.sql`

**Tables**:
- `Users` - User profiles and authentication
- `Interests` - Available interests
- `UserInterests` - User-interest relationships (many-to-many)
- `Friendships` - Friend relationships
- `FriendRequests` - Pending friend requests

**Key Features**:
- Firebase UID integration
- Unique constraints on email and username
- Timestamps for created_at

### Event Database (`event_db`)

**File**: `initEvent.sql`

**Tables**:
- `Events` - Event information
- `EventInterests` - Event-interest relationships (many-to-many)
- `Tasks` - Async task tracking for event creation

**Key Features**:
- DateTime fields for event scheduling
- Foreign key to Users table (created_by)
- Task status tracking

### Feed Database (`feed_db`)

**File**: `initFeed.sql`

**Tables**:
- `Posts` - User posts
- `PostInterests` - Post-interest relationships (many-to-many)
- `PostLikes` - Post like tracking
- `Interests` - Available interests

**Key Features**:
- Like system with composite primary key
- Timestamps for created_at and updated_at
- Foreign key to Users table (created_by)

## 🚀 Setup

### Prerequisites

- MySQL 8.0+ server
- Database access credentials

### Local Setup

1. **Create databases**
   ```sql
   CREATE DATABASE user_db;
   CREATE DATABASE event_db;
   CREATE DATABASE feed_db;
   ```

2. **Initialize User Database**
   ```bash
   mysql -u root -p user_db < initUser.sql
   ```

3. **Initialize Event Database**
   ```bash
   mysql -u root -p event_db < initEvent.sql
   ```

4. **Initialize Feed Database**
   ```bash
   mysql -u root -p feed_db < initFeed.sql
   ```

### Cloud SQL Setup (GCP)

1. **Create Cloud SQL instances**
   ```bash
   # User DB
   gcloud sql instances create user-db-instance \
     --database-version=MYSQL_8_0 \
     --tier=db-f1-micro \
     --region=us-central1
   
   # Feed DB
   gcloud sql instances create feed-db-instance \
     --database-version=MYSQL_8_0 \
     --tier=db-f1-micro \
     --region=us-central1
   ```

2. **Create databases**
   ```bash
   gcloud sql databases create user_db --instance=user-db-instance
   gcloud sql databases create feed_db --instance=feed-db-instance
   ```

3. **Initialize schemas**
   ```bash
   # Connect and run scripts
   gcloud sql connect user-db-instance --user=root
   # Then run: source initUser.sql;
   
   gcloud sql connect feed-db-instance --user=root
   # Then run: source initFeed.sql;
   ```

### VM MySQL Setup (Event DB)

For Event Database on Compute Engine VM:

1. **SSH into VM**
   ```bash
   gcloud compute ssh event-db-vm --zone=us-central1-a
   ```

2. **Create database**
   ```sql
   CREATE DATABASE event_db;
   ```

3. **Initialize schema**
   ```bash
   mysql -u root -p event_db < initEvent.sql
   ```

## 📊 Schema Details

### Users Table
```sql
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    firebase_uid VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    profile_picture TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Events Table
```sql
CREATE TABLE Events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255),
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(user_id)
);
```

### Posts Table
```sql
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(user_id)
);
```

## 🔐 Database Users

### Create Service User

For each database, create a dedicated service user:

```sql
-- User DB
CREATE USER 'microservice_user'@'%' IDENTIFIED BY 'secure_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON user_db.* TO 'microservice_user'@'%';
FLUSH PRIVILEGES;

-- Event DB
CREATE USER 'microservice_user'@'%' IDENTIFIED BY 'secure_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON event_db.* TO 'microservice_user'@'%';
FLUSH PRIVILEGES;

-- Feed DB
CREATE USER 'microservice_user'@'%' IDENTIFIED BY 'secure_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON feed_db.* TO 'microservice_user'@'%';
FLUSH PRIVILEGES;
```

## 🔄 Migration Notes

### Adding New Tables

1. Create migration SQL file (e.g., `migrations/001_add_table.sql`)
2. Test on local database first
3. Apply to Cloud SQL instances
4. Update this README

### Modifying Existing Tables

1. Create ALTER TABLE migration
2. Test thoroughly
3. Consider downtime for production
4. Backup databases before migration

## 🧪 Testing

### Verify Schema Creation

```sql
-- Check tables in User DB
USE user_db;
SHOW TABLES;
DESCRIBE Users;

-- Check tables in Event DB
USE event_db;
SHOW TABLES;
DESCRIBE Events;

-- Check tables in Feed DB
USE feed_db;
SHOW TABLES;
DESCRIBE Posts;
```

### Verify Foreign Keys

```sql
-- Check foreign key constraints
SELECT 
    TABLE_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'user_db'
  AND REFERENCED_TABLE_NAME IS NOT NULL;
```

## 📝 Notes

- All databases use MySQL 8.0+ features
- Foreign keys reference Users table (shared across services)
- Timestamps use MySQL TIMESTAMP type
- Unique constraints ensure data integrity
- Indexes are created on frequently queried columns

## 🔗 Related Documentation

- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Cloud SQL Documentation](https://cloud.google.com/sql/docs)
- [Database Design Best Practices](https://www.mysql.com/why-mysql/presentations/mysql-best-practices-for-designing-schemas/)

## 🤝 Contributing

When modifying schemas:
1. Create migration script
2. Test on local database
3. Update this README
4. Document breaking changes
5. Provide rollback script if needed
