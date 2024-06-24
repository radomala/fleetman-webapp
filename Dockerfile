# Étape 1 : Utiliser une image node pour builder l'application Angular
FROM node:14.17.0-alpine as build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . ./
RUN npm run build --prod




# Étape 2 : Utiliser une image nginx pour servir l'application Angular
FROM nginx:1.14.0-alpine

# Copier le fichier de configuration Nginx
COPY nginx.conf /etc/nginx/nginx.conf

COPY --from=build /usr/src/app/dist/fleetman-webapp /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]




