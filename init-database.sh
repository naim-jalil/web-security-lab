#!/bin/bash

echo "Initializing VulnerableApp database..."

# Wait for SQL Server to be ready
echo "Waiting for SQL Server to start..."
sleep 15

# Check if init.sql exists in database/init-scripts directory
if [ -f "./vulnerable-app/database/init-scripts/init.sql" ]; then
    INIT_SQL_PATH="./vulnerable-app/database/init-scripts/init.sql"
    echo "Found initialization script at $INIT_SQL_PATH"
else
    echo "init.sql not found in expected location. Will try to use setup-day1.sh script."
    
    if [ -f "./setup-day1.sh" ]; then
        echo "Running setup-day1.sh script..."
        chmod +x ./setup-day1.sh
        ./setup-day1.sh
        exit $?
    else
        echo "No initialization scripts found. Creating a basic one..."
        
        mkdir -p ./vulnerable-app/database/init-scripts
        
        # Create a basic init.sql file
        cat > ./vulnerable-app/database/init-scripts/init.sql << 'EOSQL'
USE master;
GO

-- Create database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'VulnerableApp')
BEGIN
    CREATE DATABASE VulnerableApp;
END
GO

USE VulnerableApp;
GO

-- Create Products table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Products')
BEGIN
    CREATE TABLE Products (
        ProductId INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(100) NOT NULL,
        Description NVARCHAR(MAX),
        Price DECIMAL(10, 2) NOT NULL,
        Category NVARCHAR(50),
        ImageUrl NVARCHAR(255)
    );
END
GO

-- Create Users table (intentionally insecure)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
BEGIN
    CREATE TABLE Users (
        UserId INT IDENTITY(1,1) PRIMARY KEY,
        Username NVARCHAR(50) NOT NULL,
        Password NVARCHAR(50) NOT NULL, -- Deliberately insecure storage
        Email NVARCHAR(100),
        FullName NVARCHAR(100),
        IsAdmin BIT NOT NULL DEFAULT 0
    );
END
GO

-- Insert sample users (with plain text passwords)
IF NOT EXISTS (SELECT * FROM Users WHERE Username = 'admin')
BEGIN
    INSERT INTO Users (Username, Password, Email, FullName, IsAdmin)
    VALUES 
        ('admin', 'admin123', 'admin@example.com', 'Admin User', 1),
        ('john', 'password123', 'john@example.com', 'John Smith', 0),
        ('alice', 'alice2023', 'alice@example.com', 'Alice Johnson', 0);
END
GO

-- Insert sample products if not exist
IF NOT EXISTS (SELECT * FROM Products WHERE Name = 'Laptop')
BEGIN
    INSERT INTO Products (Name, Description, Price, Category, ImageUrl)
    VALUES
        ('Laptop', 'High-performance laptop for developers', 1299.99, 'Electronics', '/images/laptop.jpg'),
        ('Smartphone', '5G-enabled smartphone with great camera', 899.99, 'Electronics', '/images/smartphone.jpg'),
        ('Database Book', 'Learn SQL injection techniques', 49.99, 'Books', '/images/book.jpg'),
        ('Security Camera', 'Monitor your home security', 199.99, 'Security', '/images/camera.jpg');
END
GO

-- Create Orders table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Orders')
BEGIN
    CREATE TABLE Orders (
        OrderId INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT FOREIGN KEY REFERENCES Users(UserId),
        OrderDate DATETIME DEFAULT GETDATE(),
        TotalAmount DECIMAL(10, 2)
    );
END
GO

-- Create Messages table (for XSS demos)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Messages')
BEGIN
    CREATE TABLE Messages (
        MessageId INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT FOREIGN KEY REFERENCES Users(UserId),
        Title NVARCHAR(100),
        Content NVARCHAR(MAX),
        PostedDate DATETIME DEFAULT GETDATE(),
        IsPublic BIT DEFAULT 1
    );
END
GO

-- Insert sample messages (with XSS payloads)
IF NOT EXISTS (SELECT * FROM Messages WHERE Title = 'Welcome Message')
BEGIN
    INSERT INTO Messages (UserId, Title, Content, IsPublic)
    VALUES
        (1, 'Welcome Message', 'Welcome to our secure website!', 1),
        (2, 'Product Question', 'When will the <script>alert("XSS")</script> laptop be back in stock?', 1),
        (3, 'Security Notice', 'Please update your passwords regularly.', 1);
END
GO
EOSQL
        
        INIT_SQL_PATH="./vulnerable-app/database/init-scripts/init.sql"
    fi
fi

# Copy and execute the SQL file
echo "Copying SQL file to container..."
CONTAINER_NAME=$(docker compose ps -q db)
if [ -z "$CONTAINER_NAME" ]; then
    echo "Database container not found. Make sure it's running."
    exit 1
fi

docker cp "$INIT_SQL_PATH" $CONTAINER_NAME:/tmp/init.sql

echo "Executing SQL script..."
docker exec -i $CONTAINER_NAME /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "P@ssw0rd!" -C -N -t 30 -b -e -i /tmp/init.sql

# Verify database was created
echo "Verifying database was created..."
docker exec -i $CONTAINER_NAME /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "P@ssw0rd!" -C -Q "SELECT name FROM sys.databases WHERE name = 'VulnerableApp'"

echo "Database initialization completed."
