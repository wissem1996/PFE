#!/bin/sh

echo ${BACKEND} | sed -i "s#backend:8082#${BACKEND}#g" /usr/share/nginx/html/*.*

exec nginx -g "daemon off;"