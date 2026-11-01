#!/bin/bash
set -euo pipefail

echo "Обновление кода"
git pull origin main

echo "Пересобираем образы"
docker compose -f docker-compose.prod.yml up -d --build

echo "Копируем статику из контейнера на хост"
docker compose -f docker-compose.prod.yml create backend
docker compose -f docker-compose.prod.yml cp backend:/app/staticfiles/. ./staticfiles/
docker compose -f docker-compose.prod.yml rm -f backend

echo "Применяем миграции"
docker compose -f docker-compose.prod.yml exec -T backend python manage.py migrate --noinput

echo "Перезапускаем nginx на сервере"
sudo systemctl reload nginx

echo "Деплой complete"
