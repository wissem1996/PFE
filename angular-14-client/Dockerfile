### STAGE 1: Build ###
FROM node:16.13-alpine AS build
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build
RUN ls /usr/src/app/dist/
### STAGE 2: Run ###
FROM nginx:1.17.1-alpine
ENV BACKEND=backend:8080
COPY --from=build /usr/src/app/dist/angular-14-crud-example /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d
COPY entrypoint.sh .
RUN chmod 775 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]