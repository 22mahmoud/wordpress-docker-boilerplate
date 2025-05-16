#!/bin/sh

MAX_RETRIES=20
RETRY_DELAY=1

# Wait for Database
for attempt in $(seq 1 $MAX_RETRIES); do
  if wp db check >/dev/null 2>&1; then
    echo "✅ Database is ready!"
    break
  fi
  echo "⏳ Waiting for Database... ($attempt/$MAX_RETRIES)"
  if [ "$attempt" -eq "$MAX_RETRIES" ]; then
    echo "❌ Database not available after $MAX_RETRIES attempts. Exiting."
    exit 1
  fi
  sleep "$RETRY_DELAY"
done

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

# Wait for Redis
for attempt in $(seq 1 $MAX_RETRIES); do
  if wp redis status >/dev/null 2>&1; then
    echo "✅ Redis is ready!"
    break
  fi
  echo "⏳ Waiting for Redis... ($attempt/$MAX_RETRIES)"
  if [ "$attempt" -eq "$MAX_RETRIES" ]; then
    echo "❌ Redis not available after $MAX_RETRIES attempts. Exiting."
    exit 1
  fi
  sleep "$RETRY_DELAY"
done

# Enable Redis
wp redis enable

if ! wp theme is-active skin; then
  echo "🎨 Activating Skin theme..."
  wp theme activate skin
else
  echo "🎨 Skin theme is already active."
fi
