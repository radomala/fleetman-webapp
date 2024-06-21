# Étape 1 : Utiliser une image node pour builder l'application Angular
FROM node:14 AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . ./
RUN npm run build --prod

# Étape 2 : Utiliser une image nginx pour servir l'application Angular
FROM nginx:alpine


# Installer les dépendances nécessaires, y compris Python 3 et j2cli
RUN apk --no-cache add python3 py3-pip ca-certificates && \
    update-ca-certificates && \
    pip3 install --trusted-host pypi.python.org j2cli[yaml]

RUN apk --no-cache add python2 py2-pip ca-certificates && \
    update-ca-certificates && \
    pip2 install --trusted-host pypi.python.org j2cli[yaml]

RUN apk add --update bash && rm -rf /var/cache/apk/*

COPY --from=build /dist/fleetman-webapp /usr/share/nginx/html

# Copier le fichier de configuration Nginx
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
