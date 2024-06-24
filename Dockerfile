# Étape 1 : Utiliser une image node pour builder l'application Angular
FROM node:14 AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . ./
RUN npm run build --prod

# Étape 2 : Utiliser une image nginx pour servir l'application Angular
FROM nginx:1.14.0-alpine

apk add --update --no-cache curl py-pip


RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /dist/fleetman-webapp /usr/share/nginx/html

# Copier le fichier de configuration Nginx
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
