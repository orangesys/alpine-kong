#!/usr/local/bin/dumb-init /bin/bash
set -e

# Disabling nginx daemon mode
export KONG_NGINX_DAEMON="off"

# forward request and error logs to docker log collector
mkdir -p /var/log/nginx
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log

[ -z "$KONG_NGINX_DAEMON" ] && export KONG_NGINX_DAEMON="off"

exec "$@"
