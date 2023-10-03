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
COPY --from=build /usr/src/app/dist/angular-14-crud-example /usr/share/nginx/html
EXPOSE 80
CMD ["/bin/sh",  "-c",  "envsubst < /usr/share/nginx/html/assets/env.sample.js > /usr/share/nginx/html/assets/env.js && exec nginx -g 'daemon off;'"]