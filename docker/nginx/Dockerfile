FROM nginx:alpine

WORKDIR /var/www/web

RUN rm -rf /etc/nginx/conf.d/*

COPY ./docker/nginx/nginx.prod.conf /etc/nginx/nginx.conf

COPY --from=php-production /var/www/web .
