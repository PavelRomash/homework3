# Задача 1.
Ссылка на репозиторий: https://github.com/PavelRomash/homework3/tree/my-docker-files

# Задача 2.
Образ создан и опубликован в Yandex cloud в Container Registry.
Отчет уязвимостей добавлен в репозиторий.
Ссылка: https://github.com/PavelRomash/homework3/blob/cb3482230ff8d2e9da982dd7d60cf479c2d1d71f/%D0%BE%D1%82%D1%87%D0%B5%D1%82%20%D1%81%D0%BA%D0%B0%D0%BD%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F.csv

# Задача 3.
Добавил скриншот в репозиторий (скриншот sql.png)
Ссылка: https://github.com/PavelRomash/homework3/blob/cb3482230ff8d2e9da982dd7d60cf479c2d1d71f/%D1%81%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%20sql.png
<img width="1803" height="923" alt="скриншот sql" src="https://github.com/user-attachments/assets/7a1e5745-6a43-49ba-9b57-156a07cb6940" />

# Задача 4.
Добавил скриншот в репозиторий (скриншот sql_result.png)
Ссылка https://github.com/PavelRomash/homework3/blob/cb3482230ff8d2e9da982dd7d60cf479c2d1d71f/sql_result.png
<img width="1819" height="937" alt="sql_result" src="https://github.com/user-attachments/assets/c8e28978-ea4e-4716-adf0-9928aa4ce8d3" />
Ссылка: https://github.com/PavelRomash/homework3/tree/my-docker-files

# Задача 5.
Скрипт для резервного копирования БД

/opt/backup-mysql.sh

bash
#!/bin/bash

### Директория для бэкапов
BACKUP_DIR="/opt/backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.sql"

### Создаем директорию если не существует
mkdir -p $BACKUP_DIR

### Загружаем переменные окружения из .env файла
set -a
source /opt/homework3/.env
set +a

echo "=== Starting MySQL backup with schnitzler/mysqldump ==="
echo "User: $MYSQL_USER"
echo "Database: $MYSQL_DATABASE"

### Останавливаем все предыдущие контейнеры schnitzler/mysqldump
echo "Cleaning up previous containers..."
docker ps -q --filter "ancestor=schnitzler/mysqldump" | xargs -r docker stop 2>/dev/null

### Выполняем бэкап используя образ schnitzler/mysqldump
echo "Creating backup..."
docker run --rm \
  --network homework3_backend \
  -v $BACKUP_DIR:/backup \
  --entrypoint /bin/sh \
  schnitzler/mysqldump \
  -c "mysqldump -h db-mysql -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE --no-tablespaces --skip-lock-tables > /backup/backup_$TIMESTAMP.sql"

### Проверяем успешность выполнения
if [ $? -eq 0 ] && [ -s $BACKUP_FILE ]; then
    echo "ackup successful: $BACKUP_FILE"
    echo "Backup size: $(du -h $BACKUP_FILE | cut -f1)"
    echo "Number of backup files: $(ls -1 $BACKUP_DIR/backup_*.sql 2>/dev/null | wc -l)"
    
    # Удаляем старые бэкапы (оставляем последние 10)
    ls -t $BACKUP_DIR/backup_*.sql 2>/dev/null | tail -n +11 | xargs rm -f
    echo "Cleaned up old backups (kept last 10)"
else
    echo "Backup failed"
    rm -f "$BACKUP_FILE"
    exit 1
fi


Команда для добавления в crontab:
* * * * * /opt/backup-mysql.sh >> /var/log/mysql-backup.log 2>&1

Скриншот с несколькими резервными копиями в "/opt/backup"
Ссылка: https://github.com/PavelRomash/homework3/blob/0b7c57915ee592b82df05cb676f8c8b1eb9f8d51/%D1%81%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%20backup.png
<img width="1825" height="939" alt="ls -la opt backup" src="https://github.com/user-attachments/assets/e93378ce-598c-44f0-bfee-bc9f5237db0e" />


# Задача 6
Скачивание образа
<img width="1830" height="973" alt="hashicorp" src="https://github.com/user-attachments/assets/14e7a4ae-a97f-4299-bac0-fa70ee3eb03f" />

Анализируем образ с помощью dive
<img width="1827" height="931" alt="dive" src="https://github.com/user-attachments/assets/978f20cb-edae-4aa5-b634-a7ee264c0b8a" />

Сохраняем образ в tar архив
<img width="1002" height="89" alt="docker save" src="https://github.com/user-attachments/assets/643b2395-88ab-4c2c-91bd-6566606c2522" />

Извлечен файл bin/terraform
<img width="715" height="193" alt="bin terra" src="https://github.com/user-attachments/assets/6e6b901d-6825-40f6-b77e-1af0ff557a22" />

Копируем и проверям установку terraform
<img width="849" height="126" alt="version" src="https://github.com/user-attachments/assets/e9ce024c-f731-4a6a-90e3-ccec7f6f67ee" />

# Задача 6.1

Удаляем terraform
<img width="812" height="86" alt="rm" src="https://github.com/user-attachments/assets/2ace49c9-d140-42e0-a116-8e4bb76866ca" />

Создаем временный контейнер
<img width="1006" height="65" alt="cont" src="https://github.com/user-attachments/assets/5b39214b-ffaf-476d-b7f8-84c05393ebfd" />

Копируем файл с помощью docker cp
<img width="960" height="67" alt="cp" src="https://github.com/user-attachments/assets/d15fe69b-30a9-4f58-a054-84f112738525" />

Устанавливаем скопированный файл и проверяем установку 
<img width="1250" height="137" alt="version 2" src="https://github.com/user-attachments/assets/4842ee36-5395-4f51-9dfa-55a51ac0db12" />


