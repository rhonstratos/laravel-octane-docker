#!/bin/bash

echo "🔒 Booting Production Environment..."
echo "📦 Compiling assets and building immutable images..."

# Target the prod compose file and force a build
docker compose -f docker-compose.prod.yml up -d --build

echo ""
echo "✅ Production stack is running!"
echo "🌐 Production API: http://localhost"