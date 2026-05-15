#!/bin/bash

echo "🚀 Booting Development Environment..."
docker compose up -d

echo ""
echo "✅ Development stack is running!"
echo "🌐 API: http://localhost"
echo "🗄️  phpMyAdmin: http://localhost:8888"