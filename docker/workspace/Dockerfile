FROM php:8.3-cli-alpine

ARG UID=1000
ARG GID=1000

RUN addgroup -g "${GID}" -S fpm \
  && adduser -u "${UID}" -G fpm -S -s /sbin/nologin fpm

WORKDIR /var/www

RUN apk add --no-cache \
  bash \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Install Composer and dependencies
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# Install WP-CLI globally
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x /usr/local/bin/wp

USER fpm
ENTRYPOINT []
CMD ["bash"]
