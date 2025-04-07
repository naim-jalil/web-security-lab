#!/bin/bash
echo "Setting up Day 1: Introduction to Web Application Security and OWASP Top 10"

# Reset environment completely
docker compose down
docker volume rm web-security-lab_sqldata || true
docker volume rm web-security-lab_security-reports || true

# Start with fresh setup
docker compose up -d db

# Initialize the database using our script
echo "Running database initialization script..."
./init-database.sh

# Start the web application with basic vulnerabilities
docker compose up -d web-security-lab

# Print access information
echo "Day 1 environment is ready!"
echo "Access the vulnerable web application at: http://localhost:8080"
echo "Login credentials:"
echo "  Regular user: john / password123"
echo "  Admin user: admin / admin123"
echo "Today's focus: OWASP Top 10 vulnerabilities identification"