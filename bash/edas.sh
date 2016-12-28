#!/usr/bin/env bash
set -e

docker ps -a -f name=edas-config-center>/dev/null

[ $? -eq 0 ] && docker run --name=edas-config-center -d -p $1:8080 index.tenxcloud/revolc/edas-config-center:latest
