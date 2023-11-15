# ### STAGE 1: Build ###
# FROM node:16.13-alpine AS build
# WORKDIR /usr/src/app
# COPY /angular-14-client/package.json /angular-14-client/package-lock.json .
# RUN npm install
# COPY angular-14-client/ .
# RUN ls /usr/src/app/
# RUN npm run build
### STAGE 2: Run ##
FROM wissemgh5/pfe_nginx:316174deec459b84195c9d2dcd5fa54f99d96542
WORKDIR /opt/nginx
USER pfe
ENV BACKEND=backend:8080
COPY --chown=pfe:pfe ./angular-14-client/dist/angular-14-crud-example /usr/share/nginx/html
COPY --chown=pfe:pfe ./angular-14-client/entrypoint.sh .
COPY --chown=pfe:pfe  ./angular-14-client/default.conf /etc/nginx/conf.d
RUN chmod 775 /opt/nginx/entrypoint.sh
ENTRYPOINT ["/opt/nginx/entrypoint.sh"]
