#!/bin/bash
set -e

echo "🚀 Starting 3x-ui + nginx for Railway..."

# Railway provides $PORT automatically
if [ -z "$PORT" ]; then
    echo "⚠️  WARNING: \$PORT not set. Using fallback 3000"
    export NGINX_PORT=3000
else
    export NGINX_PORT=$PORT
fi

echo "📡 Listening on Railway port: $NGINX_PORT"

export PANEL_PATH=${PANEL_PATH:-/managepanel/}
export SUB_PATH=${SUB_PATH:-/sub/}
export XUI_PORT=${XUI_PORT:-2053}
export SUB_PORT=${SUB_PORT:-2096}
export INBOUND_PORT=${INBOUND_PORT:-8080}

cd /usr/local/x-ui

# Apply settings ONLY on first run
if [ ! -f /etc/x-ui/db.sqlite3 ]; then
    echo "🔧 First run - applying initial settings..."
    ./x-ui setting -port $XUI_PORT -webBasePath "$PANEL_PATH" || true
    echo "✅ Initial settings applied."
else
    echo "ℹ️ Database exists - skipping initial settings."
fi

echo "🔧 Generating nginx config for port $NGINX_PORT..."

envsubst '${NGINX_PORT} ${PANEL_PATH} ${SUB_PATH} ${XUI_PORT} ${SUB_PORT} ${INBOUND_PORT}' \
    < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "▶️ Starting 3x-ui..."
./x-ui run > /var/log/x-ui/x-ui.log 2>&1 &

sleep 3

echo "▶️ Starting nginx on port $NGINX_PORT..."
nginx -t
exec nginx -g "daemon off;"