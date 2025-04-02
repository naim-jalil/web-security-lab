#!/bin/bash

echo "Starting Web Security Lab..."

# Step 1: Check for docker compose.override.yml and back it up
if [ -f "docker compose.override.yml" ]; then
    echo "Found docker compose.override.yml - backing it up to avoid HTTPS settings"
    mv docker compose.override.yml docker compose.override.yml.bak
    echo "Backed up docker compose.override.yml to docker compose.override.yml.bak"
fi

# Step 2: Replace the docker compose.yml with our HTTP-only version
echo "Backing up original docker compose.yml"
cp docker compose.yml docker compose.yml.original
echo "Replacing with HTTP-only version"
cat fixed-docker compose.yml > docker compose.yml

# Step 3: Start the database container first
echo "Starting database container..."
docker compose up -d db

# Step 4: Initialize the database
echo "Initializing database..."
chmod +x init-database.sh
./init-database.sh

# Step 5: Start the remaining containers
echo "Starting all containers..."
docker compose up -d

# Step 6: Display container status
echo "Container status:"
docker compose ps

# Step 7: Display access URLs
echo ""
echo "Web Security Lab is now running. Access points:"
echo "- Web Application: http://localhost:8080"
echo "- Security Tools (ZAP): http://localhost:8090"
echo "- WAF: http://localhost:8081"
echo ""
echo "Default login credentials:"
echo "- Regular user: john / password123"
echo "- Admin user: admin / admin123"
