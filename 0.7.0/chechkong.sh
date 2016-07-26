#!/bin/bash
curl -sX POST \
 --url http://127.0.0.1:8001/apis/ \
 --data 'name=httpbin' \
 --data 'upstream_url=http://httpbin.org/' \
 --data 'request_host=kong.httpbin.org'

curl -sX GET \
  --url http://127.0.0.1:8001/apis/ \
  |jq '.data[].name == "httpbin"'

curl -sX GET \
  --header "Host: kong.httpbin.org" \
  --url http://127.0.0.1:8000/get \
  |jq '.headers["Accept"] == "*/*"'

curl -sX DELETE \
--url http://127.0.0.1:8001/apis/httpbin

curl -sX GET \
 --url http://127.0.0.1:8001/apis/ \
 |jq '.data[].name != "httpbin"'
