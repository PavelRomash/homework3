#!/bin/bash


# Останавливаем проект
docker compose down -v --remove-orphans

# Удаляем образы проекта
docker rmi homework3-web 2>/dev/null || true

# Запускаем проект
docker compose up -d --build

echo "Ожидаем полный запуск БД и healthcheck..."
sleep 45

docker compose ps

echo -e "\n=== ЛОГИ WEB КОНТЕЙНЕРА ==="
docker compose logs web --tail=30

echo -e "\n=== ПРОВЕРКА ТАБЛИЦ В БД ==="
docker compose exec db mysql -D virtd -e "SHOW TABLES;"

echo -e "\n=== ПРОВЕРКА РАБОТЫ ПРИЛОЖЕНИЯ ==="
echo "1. Через прокси (правильно):"
curl -s http://localhost:8090/

echo -e "\n2. Прямое обращение (должна быть подсказка):"
curl -s http://localhost:5000/

echo -e "\n3. Все записи в БД:"
curl -s http://localhost:8090/requests

echo -e "\n4. Статус контейнеров этого проекта:"
docker compose ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"