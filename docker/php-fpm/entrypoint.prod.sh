#!/bin/sh

set -e

echo "🏁 production entrypoint starting..."

. /usr/local/bin/entrypoint.common.sh

# echo "🔄 Running WordPress database updates..."
# wp core update-db

echo "🧹 Flushing WordPress cache..."
wp cache flush

echo "✅ Production entrypoint finished. Starting PHP-FPM..."
exec "$@"
