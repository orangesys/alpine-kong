FROM alpine:3.4
MAINTAINER gavin zhou <gavin.zhou@gmail.com>

ENV OPENRESTY_VERSION=1.11.2.1 \
 LUAROCKS_VERSION=2.4.1 \
 KONG_VERSION=0.9.4 \
 SERF_VERSION=0.8.0 \
 OPENRESTY_PREFIX=/usr/local/openresty

RUN echo "==> Installing dependencies..." \
 && apk update \
 && apk add --virtual .build-deps \
    make gcc musl-dev \
    pcre-dev openssl-dev zlib-dev ncurses-dev readline-dev \
    curl perl e2fsprogs-dev wget git unzip \
 && echo "==> Install dumb-init" \
 && curl -sSL https://github.com/Yelp/dumb-init/archive/master.tar.gz | tar -xz \
 && cd dumb-init-master && gcc -std=gnu99 -s -Wall -Werror -O3 -o /usr/local/bin/dumb-init /dumb-init-master/dumb-init.c \
 && echo "==> Downloading OpenResty..." \
 && curl -sSL http://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz | tar -xz \
 && cd openresty-* \
 && echo "==> Configuring OpenResty..." \
 && readonly NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
 && echo "using upto $NPROC threads" \
 && ./configure \
    --with-luajit \
    --with-pcre-jit \
    --with-ipv6 \
    --with-http_realip_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --without-http_ssi_module \
    --without-http_userid_module \
    --without-http_uwsgi_module \
    --without-http_scgi_module \
    -j${NPROC} \
 && echo "==> Building OpenResty..." \
 && make -j${NPROC} \
 && echo "==> Installing OpenResty..." \
 && make install \
 && export PATH="$PATH:/usr/local/openresty/bin" \
 && echo "==> Finishing..." \
 && echo "==> Configuring LuaRocks..." \
 && mkdir -p /root/luarocks \
 && cd /root/luarocks \
 && curl -sSL http://keplerproject.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz |tar -xz \
 && cd luarocks* \
 && ./configure \
    --with-lua=$OPENRESTY_PREFIX/luajit \
    --lua-suffix=jit-2.1.0-beta2 \
    --with-lua-include=$OPENRESTY_PREFIX/luajit/include/luajit-2.1 \
 && echo "==> Building&Installing OpenResty..." \
 && make build && make install \
 && echo "==> Finishing..." \
 && echo "==> Installing kong dependencies..." \
 && wget -q https://releases.hashicorp.com/serf/${SERF_VERSION}/serf_${SERF_VERSION}_linux_amd64.zip \
 && unzip serf*.zip && mv serf /usr/bin/ && rm serf*.zip \
 && luarocks install https://raw.githubusercontent.com/Mashape/kong/${KONG_VERSION}/kong-${KONG_VERSION}-0.rockspec \
 && ln -sf $OPENRESTY_PREFIX/bin/resty /usr/local/bin/resty \
 && ln -sf $OPENRESTY_PREFIX/nginx/sbin/nginx /usr/local/bin/nginx \
 && curl -sSL -o /usr/local/bin/kong https://raw.githubusercontent.com/Mashape/kong/${KONG_VERSION}/bin/kong \
 && chmod +x /usr/local/bin/kong && mkdir -p /etc/kong \
 && curl -sSL -o /etc/kong/kong.conf.default https://raw.githubusercontent.com/Mashape/kong/0.9.4/kong.conf.default \
 && apk del .build-deps \
 && apk add \
    libpcrecpp libpcre16 libpcre32 openssl libssl1.0 pcre libgcc libstdc++ e2fsprogs-dev dnsmasq perl bash \
 && echo "user=root" >> /etc/dnsmasq.conf \
 && rm -rf /var/cache/apk/* \
 && rm -rf /root/ngx_openresty /root/luarocks /dumb-init-master

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8000 8443 8001 7946
CMD ["kong", "start"]
