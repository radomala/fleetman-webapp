# Étape 1 : Construction de l'application Angular
FROM node:14 AS build

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers package.json et package-lock.json
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste des fichiers de l'application
COPY . .

# Builder l'application Angular
RUN npm run build --prod

# Étape 2 : Serveur Nginx pour les fichiers construits
FROM nginx:alpine

# Copier les fichiers construits depuis l'image de build
COPY --from=build /app/dist/nom-de-votre-projet /usr/share/nginx/html

# Copier la configuration par défaut de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Exposer le port 80
EXPOSE 80

# Démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
