FROM alpine:3.20

RUN apk add --no-cache \
    curl \
    bash \
    ca-certificates \
    socat \
    tzdata \
    sqlite \
    nginx \
    gettext \
    && ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime

# Download latest 3x-ui (change version if needed)
RUN curl -L https://github.com/MHSanaei/3x-ui/releases/download/v3.6.0/x-ui-linux-amd64.tar.gz -o /tmp/x-ui.tar.gz \
    && tar -xzf /tmp/x-ui.tar.gz -C /usr/local/ \
    && rm /tmp/x-ui.tar.gz \
    && chmod +x /usr/local/x-ui/x-ui

RUN mkdir -p /etc/x-ui /var/log/x-ui

COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Railway injects $PORT automatically
ENV NGINX_PORT=$PORT
ENV PANEL_PATH=/managepanel/
ENV SUB_PATH=/sub/
ENV XUI_PORT=2053
ENV SUB_PORT=2096
ENV INBOUND_PORT=8080

CMD ["/start.sh"]