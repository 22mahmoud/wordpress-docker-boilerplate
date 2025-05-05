#!/bin/sh

# Wait for DB to be available
until wp db check >/dev/null 2>&1; do
  echo "⏳ Waiting for the database to be ready..."
  sleep 1
done
echo "✅ Database is ready!"

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

echo "🔌 Activating all plugins (excluding: $DISABLE_PLUGINS)..."
wp plugin activate --all --exclude="$DISABLE_PLUGINS"

if ! wp theme is-active skin; then
  echo "🎨 Activating Skin theme..."
  wp theme activate skin
else
  echo "🎨 Skin theme is already active."
fi
