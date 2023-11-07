#!/bin/sh

#echo ${BACKEND} | sed -i "s#http://backend:8080/api/tutorials#${BACKEND}#g" /usr/share/nginx/html/*.*

exec nginx -g "daemon off;"
