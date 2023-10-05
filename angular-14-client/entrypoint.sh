#!/bin/sh

echo ${BACKEND} | sed -i "s#localhost:8082#${BACKEND}#g" /usr/share/nginx/html/*.*

exec nginx -g "daemon off;"
