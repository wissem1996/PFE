### STAGE 1: Build ###
FROM node:16.13-alpine AS build
WORKDIR /usr/src/app
COPY /angular-14-client/package.json /angular-14-client/package-lock.json .
RUN npm install
COPY angular-14-client/ .
RUN ls /usr/src/app/
RUN npm run build
### STAGE 2: Run ###
FROM nginx:1.17.1-alpine
WORKDIR /opt/nginx
ENV BACKEND=backend:8080
COPY --chown=pfe:pfe  --from=build /usr/src/app/dist/angular-14-crud-example /usr/share/nginx/html
#COPY --chown=pfe:pfe  ./angular-14-client/default.conf /etc/nginx/conf.d
COPY --chown=pfe:pfe  ./angular-14-client/entrypoint.sh .
RUN chmod 775 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
