#!/bin/bash
set -euo pipefail

echo "Обновление кода"
git pull origin main

echo "Пересобираем образы"
docker compose -f docker-compose.prod.yml up -d --build

echo "Применяем миграции"
docker compose -f docker-compose.prod.yml exec -T backend python manage.py migrate --noinput

echo "Перезапускаем nginx"
docker compose -f docker-compose.prod.yml exec -T nginx nginx -s reload || true

echo "Деплой complete"
