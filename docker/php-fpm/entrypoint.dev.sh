#!/bin/sh
set -e

echo "🏁 development entrypoint starting..."

echo "🎶 Running composer install..."
composer install --no-interaction --prefer-dist --optimize-autoloader

. /usr/local/bin/entrypoint.common.sh

echo "✅ Development entrypoint finished. Starting PHP-FPM..."
exec "$@"
