#!/bin/bash

echo "Checking for docker compose files in the current directory:"
ls -la docker compose*

echo -e "\nIf docker compose.override.yml is present, it will be automatically used."
echo "Let's temporarily rename it to disable it:"

if [ -f docker compose.override.yml ]; then
    mv docker compose.override.yml docker compose.override.yml.bak
    echo "Renamed docker compose.override.yml to docker compose.override.yml.bak"
else
    echo "No docker compose.override.yml found - good!"
fi

# Also check the docker images to make sure we're using the latest
echo -e "\nCurrent docker images:"
docker images

echo -e "\nLet's rebuild the web-security-lab image explicitly:"
docker compose build web-security-lab
