#!/bin/bash

set -e
PGPASSWORD="postgres"
DB_HOST="localhost"
DB_USER="postgres"
STAGE_DB="alpine_tracker_stage"
PROD_DB="alpine_prod"
BACKUP_DIR="./db_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/prod_backup_${TIMESTAMP}.sql"
mkdir -p $BACKUP_DIR

echo "========================================="
echo "Starting PROD Database Migration Pipeline"
echo "========================================="

# Шаг 1: Экспортируем схемы (без комментариев и пустых строк)
echo "=== Шаг 1: Экспорт схемы баз ==="
PGPASSWORD=$PGPASSWORD pg_dump -U $DB_USER -h $DB_HOST -s $STAGE_DB | grep -v '^--' | grep -v '^$' | grep -v '\\restrict' | grep -v '\\unrestrict' | sort > stage_schema_clean.sql
PGPASSWORD=$PGPASSWORD pg_dump -U $DB_USER -h $DB_HOST -s $PROD_DB  | grep -v '^--' | grep -v '^$' | grep -v '\\restrict' | grep -v '\\unrestrict' | sort > prod_schema_clean.sql

# Шаг 2: Проверяем различия
echo "=== Шаг 2: Поиск различий схем ==="
if diff -q stage_schema_clean.sql prod_schema_clean.sql > /dev/null; then
    echo "✓ Схемы совпадают! Миграция не требуется."
    rm -f *_schema_clean.sql
    exit 0
else
    echo "⚠️  Схемы STAGE и PROD различаются!"
    diff stage_schema_clean.sql prod_schema_clean.sql > schema_diff.txt || true
    echo "- Отличия сохранены в schema_diff.txt"
fi

# Шаг 3: Бэкап prod-базы
echo "=== Шаг 3: Бэкап PROD-BD ==="
PGPASSWORD=$PGPASSWORD pg_dump -U $DB_USER -h $DB_HOST $PROD_DB > $BACKUP_FILE
echo "- Backup сохранён: $BACKUP_FILE"

# Шаг 4: Применяем миграции к PROD
echo "=== Шаг 4: Alembic upgrade Prod ==="
if [ -f "./venv/bin/activate" ]; then
    source ./venv/bin/activate
fi

export DATABASE_URL="postgresql://$DB_USER:$PGPASSWORD@$DB_HOST:5432/$PROD_DB"
alembic upgrade head
if [ $? -eq 0 ]; then
    echo "✓ Миграция к PROD прошла успешно!"
else
    echo "❌ Ошибка миграции! Откатываю из бэкапа..."
    PGPASSWORD=$PGPASSWORD psql -U $DB_USER -h $DB_HOST $PROD_DB < $BACKUP_FILE
    exit 1
fi

# Шаг 5: Повторная сверка схем
echo "=== Шаг 5: Повторное сравнение схем ==="
PGPASSWORD=$PGPASSWORD pg_dump -U $DB_USER -h $DB_HOST -s $PROD_DB | grep -v '^--' | grep -v '^$' | grep -v '\\restrict' | grep -v '\\unrestrict' | sort > prod_schema_after_clean.sql

if diff -q stage_schema_clean.sql prod_schema_after_clean.sql > /dev/null; then
    echo "✓ Схемы полностью идентичны после миграции!"
    rm -f *_schema_clean.sql prod_schema_after_clean.sql schema_diff.txt
    exit 0
else
    echo "❌ Схемы различаются и после миграции!"
    diff stage_schema_clean.sql prod_schema_after_clean.sql
    exit 2
fi
