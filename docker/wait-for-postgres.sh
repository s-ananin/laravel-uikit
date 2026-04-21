#!/bin/sh
# wait-for-postgres.sh

[ -f /var/www/.env ] && set -a && . /var/www/.env && set +a

HOST=${DB_HOST:-localhost}
PORT=${DB_PORT:-5432}
USER=${DB_USERNAME:-test}

until pg_isready -h "$HOST" -p "$PORT" -U "$USER" > /dev/null 2>&1; do
  echo "Waiting for Postgres..."
  sleep 2
done

echo "Postgres is ready!"