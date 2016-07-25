#!/bin/bash

_kong_version=$1
_kong_tag=$2

if [ -z "${_kong_version}" ]; then
    source _VERSION
    _kong_version=$_VERSION
    _kong_tag=$_VERSION

fi

docker build --build-arg KONG_VERSION=${_kong_version} --tag "orangesys/alpine-kong:${_kong_tag}" --no-cache=true .
docker tag orangesys/alpine-kong:${_kong_tag} orangesys/alpine-kong
