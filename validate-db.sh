#!/bin/bash
# Script to validate the SQL Server database setup

echo "Checking SQL Server connection..."
docker exec -i web-security-lab_db_1 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "P@ssw0rd!" -Q "SELECT @@VERSION"

echo "Checking for VulnerableApp database..."
docker exec -i web-security-lab_db_1 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "P@ssw0rd!" -Q "SELECT name FROM sys.databases WHERE name = 'VulnerableApp'"

echo "Checking for initialization scripts..."
docker exec -i web-security-lab_db_1 ls -la /docker-entrypoint-initdb.d/

echo "Running init.sql manually if needed..."
docker exec -i web-security-lab_db_1 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "P@ssw0rd!" -i /docker-entrypoint-initdb.d/init.sql

# Check if the Users table exists in the VulnerableApp database
echo "Checking Users table..."
docker exec -i web-security-lab_db_1 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "P@ssw0rd!" -d VulnerableApp -Q "IF OBJECT_ID('Users', 'U') IS NOT NULL SELECT 'Users table exists' AS Message ELSE SELECT 'Users table does not exist' AS Message"
