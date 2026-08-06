#!/bin/bash
set -e

echo "🚀 Starting 3x-ui + nginx for Railway..."

# Use Railway's $PORT (critical fix)
export NGINX_PORT=${PORT:-3000}

# Default paths (can be overridden via Railway Variables)
export PANEL_PATH=${PANEL_PATH:-/managepanel/}
export SUB_PATH=${SUB_PATH:-/sub/}
export XUI_PORT=${XUI_PORT:-2053}
export SUB_PORT=${SUB_PORT:-2096}
export INBOUND_PORT=${INBOUND_PORT:-8080}

cd /usr/local/x-ui

# Only apply settings on first run (important for Railway)
if [ ! -f /etc/x-ui/db.sqlite3 ]; then
    echo "🔧 First run detected - applying initial panel settings..."
    ./x-ui setting -port $XUI_PORT -webBasePath "$PANEL_PATH" || true
    echo "✅ Initial settings applied."
else
    echo "ℹ️ Database exists - skipping initial settings (use Volume to persist)."
fi

echo "🔧 Generating nginx.conf for port: $NGINX_PORT"

# Create nginx config from template
envsubst '${NGINX_PORT} ${PANEL_PATH} ${SUB_PATH} ${XUI_PORT} ${SUB_PORT} ${INBOUND_PORT}' \
    < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "▶️ Starting 3x-ui in background..."
./x-ui run > /var/log/x-ui/x-ui.log 2>&1 &
XUI_PID=$!

sleep 3

echo "▶️ Starting nginx on port $NGINX_PORT..."
nginx -t
exec nginx -g "daemon off;"