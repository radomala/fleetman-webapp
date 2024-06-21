# Étape 1 : Utiliser une image node pour builder l'application Angular
FROM node:14 AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . ./
RUN npm run build --prod

# Étape 2 : Utiliser une image nginx pour servir l'application Angular
FROM nginx:alpine

# Installer Python 3 et j2cli
RUN apk --no-cache add python3 py3-pip && \
    pip3 install j2cli[yaml]

RUN apk --no-cache add \
      python2 \
      py2-pip && \
    pip2 install j2cli[yaml]

COPY --from=build /dist/fleetman-webapp /usr/share/nginx/html

# Copier le fichier de configuration Nginx
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
