<<<<<<< HEAD
#!/bin/bash
echo "Resetting all environments and volumes"

# Stop all containers
docker compose down

# Remove all volumes
docker volume rm web-security-lab_sqldata || true
docker volume rm web-security-lab_security-reports || true

echo "All environments have been reset"
echo "To start a specific day's environment, run the corresponding setup script:"
echo "  ./setup-day1.sh"
echo "  ./setup-day2.sh"
=======
#!/bin/bash
echo "Resetting all environments and volumes"

# Stop all containers
docker compose down

# Remove all volumes
docker volume rm web-security-lab_sqldata || true
docker volume rm web-security-lab_security-reports || true

echo "All environments have been reset"
echo "To start a specific day's environment, run the corresponding setup script:"
echo "  ./setup-day1.sh"
echo "  ./setup-day2.sh"
>>>>>>> master
echo "  etc."