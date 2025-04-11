#!/bin/bash
echo "Setting up Day 5: Client-Side Security and Security Testing"

# Stop services but preserve volumes
docker compose down

# Start the database
docker compose up -d db

# Wait for database to be ready
echo "Waiting for database to initialize..."
sleep 10

# Start the web application and security tools
docker compose up -d web-security-lab security-tools waf

# Inject XSS vulnerable content into the database
docker exec -i web-security-lab-db /opt/mssql-tools18/bin/sqlcmd -S web-security-lab-db -U sa -P "P@ssw0rd!" -C -N -t 30 -b -e -Q "
USE VulnerableApp;
-- Add products with XSS payloads
INSERT INTO Products (Name, Description, Price, Category, ImageUrl)
VALUES ('XSS Demo Product', '<script>alert(\"XSS Attack\")</script>Vulnerable product description', 29.99, 'Security', '/images/xss.jpg');

-- Add messages with XSS payloads
INSERT INTO Messages (UserId, Title, Content, IsPublic)
VALUES (1, 'Security Notice', 'This forum contains <script>document.cookie</script> security vulnerabilities', 1);
"

echo "Day 5 environment is ready!"
echo "Access the vulnerable web application at: http://localhost:8080"
echo "Access OWASP ZAP at: http://localhost:8090"
echo "Access Web Application Firewall at: http://localhost:8081"

echo "Today's focus: XSS vulnerabilities, CSRF attacks, and security testing tools"