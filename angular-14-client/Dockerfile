# ### STAGE 1: Build ###
# FROM node:16.13-alpine AS build
# WORKDIR /usr/src/app
# COPY /angular-14-client/package.json /angular-14-client/package-lock.json .
# RUN npm install
# COPY angular-14-client/ .
# RUN ls /usr/src/app/
# RUN npm run build
### STAGE 2: Run ###
FROM wissemgh5/pfe_nginx:2a739a43dcf389225f49f082fa080aaf69d74880
WORKDIR /opt/nginx
USER pfe
ENV BACKEND=backend:8080
COPY --chown=pfe:pfe ./angular-14-client/dist/angular-14-crud-example /usr/share/nginx/html
COPY --chown=pfe:pfe ./angular-14-client/entrypoint.sh .
RUN chmod 775 /opt/nginx/entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 80 443

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
