#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color (reset to default)

echo -e "${GREEN}Stopping containers${NC}"
if docker compose stop; then
    echo -e "${GREEN}Containers stopped successfully.${NC}"
else
    echo -e "${RED}Failed to stop containers.${NC}"
    exit 1
fi

echo -e "${GREEN}Removing containers${NC}"
if docker compose rm -f; then
    echo -e "${GREEN}Containers removed successfully.${NC}"
else
    echo -e "${RED}Failed to remove containers.${NC}"
    exit 1
fi

echo -e "${GREEN}Pulling latest images${NC}"
if docker compose pull; then
    echo -e "${GREEN}Images pulled successfully.${NC}"
else
    echo -e "${RED}Failed to pull images.${NC}"
    exit 1
fi

echo -e "${GREEN}Starting Docker Compose${NC}"
if docker compose up -d --force-recreate; then
    echo -e "${GREEN}Docker Compose started successfully.${NC}"
else
    echo -e "${RED}Failed to start Docker Compose.${NC}"
    exit 1
fi

echo -e "${GREEN}local-llm containers updated.${NC}"

# Loop through the models and update them for the first Ollama instance
models=$(docker exec -i local-llm-ollama ollama list | awk 'NR>1 {print $1}')
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to list models.${NC}"
    exit 1
fi

for model in $models; do
    echo -e "${GREEN}Updating $model${NC}"
    if docker exec -i local-llm-ollama ollama pull "$model"; then
        echo -e "${GREEN}$model updated successfully.${NC}"
    else
        echo -e "${RED}Failed to update $model.${NC}"
    fi
done

echo -e "${GREEN}DONE. All models have been updated.${NC}"
