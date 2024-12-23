#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color (reset to default)

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <your_domain>"
    exit 1
fi

echo -e "${GREEN}Creating directories${NC}"

# Check and create directories if they don't exist
if [ ! -d "ollama" ]; then
    mkdir ollama
    echo -e "${GREEN}Directory 'ollama' created.${NC}"
else
    echo -e "${GREEN}Directory 'ollama' already exists.${NC}"
fi

if [ ! -d "open-webui-backend" ]; then
    mkdir open-webui-backend
    echo -e "${GREEN}Directory 'open-webui-backend' created.${NC}"
else
    echo -e "${GREEN}Directory 'open-webui-backend' already exists.${NC}"
fi

if [ ! -e ".env" ]; then
    echo -e "${GREEN}.env file doesn't exist, creating it.${NC}"
    touch .env
    echo "TUNNEL_TOKEN=<ADD YOUR CLOUDFLARE TUNNEL TOKEN>" > .env
    echo -e "${RED}.env file was created. Don't forget to edit this file to add your CloudFlare Tunnel Token.${NC}"
else
    echo -e "${GREEN}.env file already exists.${NC}"
fi

FILE="./nginx/conf.d/open-webui.conf"
SEARCH_STRING="<YOUR_DOMAIN>"
REPLACE_STRING="$1"

# Use sed to perform find and replace
if sed -i "s/${SEARCH_STRING}/${REPLACE_STRING}/g" "$FILE"; then
    echo -e "${GREEN}Replaced all occurrences of '${SEARCH_STRING}' with '${REPLACE_STRING}' in file: ${FILE}${NC}"
else
    echo -e "${RED}Error while replacing all occurrences of '${SEARCH_STRING}' with '${REPLACE_STRING}' in file: ${FILE}${NC}"
    exit 1
fi

echo -e "${GREEN}Pulling latest images${NC}"
docker compose pull

echo -e "${GREEN}Starting Docker Compose${NC}"
docker compose up -d --force-recreate

echo -e "${GREEN}DONE. You can pull your first model using this command: ${NC}docker exec local-llm-ollama ollama pull llama3.2:latest"