#!/usr/bin/dumb-init /bin/sh

set -ex

# Disabling nginx daemon mode
export KONG_NGINX_DAEMON="off"

[ -z "$KONG_NGINX_DAEMON" ] && export KONG_NGINX_DAEMON="off"

ulimit -n 4096

exec "$@"
