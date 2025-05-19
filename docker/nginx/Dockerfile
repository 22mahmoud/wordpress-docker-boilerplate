FROM nginx:alpine

WORKDIR /var/www/web

# RUN rm -rf /etc/nginx/conf.d/*

COPY ./docker/nginx/nginx.prod.conf /etc/nginx/nginx.conf

COPY --from=ghcr.io/22mahmoud/php-production /var/www/web .
