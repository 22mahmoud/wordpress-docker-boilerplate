#!/bin/sh

MAX_RETRIES=20
RETRY_DELAY=1

retry() {
  cmd="$1"
  label="$2"
  attempt=1

  until eval "$cmd" >/dev/null 2>&1; do
    echo "⏳ Waiting for $label... ($attempt/$MAX_RETRIES)"
    if [ "$attempt" -ge "$MAX_RETRIES" ]; then
      echo "❌ $label not available after $MAX_RETRIES attempts. Exiting."
      exit 1
    fi
    attempt=$((attempt + 1))
    sleep "$RETRY_DELAY"
  done

  echo "✅ $label is ready!"
}

# Wait for Redis
retry "wp redis status" "Redis"

# Enable Redis
wp redis enable

# Wait for Database
retry "wp db check" "Database"

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
