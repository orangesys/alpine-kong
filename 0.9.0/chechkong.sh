#!/bin/bash

http POST http://127.0.0.1:8001/apis/ name=httpbin upstream_url=http://httpbin.org/ request_host=kong.httpbin.org

http http://127.0.0.1:8001/apis/httpbin

http http://127.0.0.1:8000/ip Host:kong.httpbin.org

#curl -sX GET \
#  --url http://127.0.0.1:8001/apis/ \
#  |jq '.data[].name == "httpbin"'
#
#curl -sX GET \
#  --header "Host: kong.httpbin.org" \
#  --url http://127.0.0.1:8000/get \
#  |jq '.headers["Accept"] == "*/*"'
#
#curl -sX DELETE \
#--url http://127.0.0.1:8001/apis/httpbin
#
#curl -sX GET \
# --url http://127.0.0.1:8001/apis/ \
# |jq '.data[].name != "httpbin"'
