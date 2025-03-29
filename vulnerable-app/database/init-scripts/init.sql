-- This script will run when the SQL Server container starts
-- Wait for the SQL Server to come up
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