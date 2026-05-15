#!/bin/bash

echo "🛑 Shutting down all Docker environments..."

# Stop the development stack
echo "Shutting down dev..."
docker compose down

# Stop the production stack
echo "Shutting down prod..."
docker compose -f docker-compose.prod.yml down

echo ""
echo "✅ All containers successfully stopped and networks cleared."