# Étape 1 : Utiliser une image node pour builder l'application Angular
FROM node:14 AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . ./
RUN npm run build --prod

# Étape 2 : Utiliser une image nginx pour servir l'application Angular
FROM nginx:alpine


# Install dependencies
RUN apk --no-cache add \
      python3 \
      py3-pip \
      ca-certificates \
      && pip3 install --upgrade pip \
      && pip3 install j2cli[yaml]

# Clean up
RUN apk del ca-certificates

# Verify installation
RUN j2 --version

RUN apk add --update bash && rm -rf /var/cache/apk/*

COPY --from=build /dist/fleetman-webapp /usr/share/nginx/html

# Copier le fichier de configuration Nginx
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
