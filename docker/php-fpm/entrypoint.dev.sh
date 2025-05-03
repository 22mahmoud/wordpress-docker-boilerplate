#!/bin/sh
set -e

echo "🎶 Running composer install..."
composer install --no-interaction --prefer-dist --optimize-autoloader

# Install WP if not yet installed
if ! wp core is-installed; then
  echo "🚀 Installing WordPress..."
  wp core install \
    --url="$WP_HOME" \
    --title="$WP_TITLE" \
    --admin_user="$WP_USER" \
    --admin_password="$WP_PASSWORD" \
    --admin_email="$WP_EMAIL"
fi

echo "🔌 Activating all plugins..."
wp plugin activate --all

echo "🎨 Activating Skin theme..."
wp theme activate skin

exec "$@"
