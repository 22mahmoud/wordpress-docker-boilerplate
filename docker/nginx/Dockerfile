FROM nginxinc/nginx-unprivileged:alpine

COPY ./docker/nginx/nginx.prod.conf /etc/nginx/nginx.conf

WORKDIR /var/www/web
EXPOSE 80
