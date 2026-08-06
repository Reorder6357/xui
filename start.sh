#!/bin/bash
set -e

echo "🚀 Starting 3x-ui + nginx for Railway..."

# Use a fixed internal port for nginx to avoid conflict
export NGINX_INTERNAL_PORT=3000

echo "📡 nginx will listen internally on port: $NGINX_INTERNAL_PORT"

export PANEL_PATH=${PANEL_PATH:-/managepanel/}
export SUB_PATH=${SUB_PATH:-/sub/}
export XUI_PORT=${XUI_PORT:-2053}
export SUB_PORT=${SUB_PORT:-2096}
export INBOUND_PORT=${INBOUND_PORT:-8081}

cd /usr/local/x-ui

if [ ! -f /etc/x-ui/db.sqlite3 ]; then
    echo "🔧 First run - applying initial settings..."
    ./x-ui setting -port $XUI_PORT -webBasePath "$PANEL_PATH" || true
    echo "✅ Initial settings applied."
else
    echo "ℹ️ Database exists - skipping initial settings."
fi

echo "🔧 Generating nginx config..."

envsubst '${NGINX_INTERNAL_PORT} ${PANEL_PATH} ${SUB_PATH} ${XUI_PORT} ${SUB_PORT} ${INBOUND_PORT}' \
    < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "▶️ Starting 3x-ui in background..."
./x-ui run > /var/log/x-ui/x-ui.log 2>&1 &

sleep 4

echo "▶️ Starting nginx on internal port $NGINX_INTERNAL_PORT..."
nginx -t
exec nginx -g "daemon off;"
