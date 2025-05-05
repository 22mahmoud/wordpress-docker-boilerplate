FROM php:8.3-fpm-alpine AS base

ARG UID=1000
ARG GID=1000

RUN addgroup -g "${GID}" -S fpm \
  && adduser -u "${UID}" -G fpm -S -s /sbin/nologin fpm

RUN sed -i "s/user = www-data/user = fpm/g" /usr/local/etc/php-fpm.d/www.conf \
  && sed -i "s/group = www-data/group = fpm/g" /usr/local/etc/php-fpm.d/www.conf \
  && sed -i 's/;pm.status_path/pm.status_path/' /usr/local/etc/php-fpm.d/www.conf

# Download and install php-fpm health check script
RUN curl -o /usr/local/bin/php-fpm-healthcheck \
  https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck \
  && chmod +x /usr/local/bin/php-fpm-healthcheck

# download Composer
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# Install WP-CLI globally
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x /usr/local/bin/wp

WORKDIR /var/www

FROM base AS builder

RUN apk add --no-cache --virtual .build-deps \
  $PHPIZE_DEPS \
  # gd support
  libjpeg-turbo-dev \
  libpng-dev \
  libwebp-dev \
  freetype-dev \
  \
  # Essentials
  libzip-dev \
  openssl-dev \
  fcgi \
  procps  \
  curl \
  git \
  unzip \
  mysql \
  mysql-client \
  \
  # language/charset
  oniguruma-dev \
  icu-dev \
  \
  # Configure and install PHP extensions
  && docker-php-ext-configure gd --with-jpeg --with-webp \
  && docker-php-ext-install -j "$(nproc)" \
  bcmath \
  exif \
  gd \
  intl \
  mbstring \
  mysqli \
  pdo_mysql \
  zip \
  opcache \
  \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*


FROM builder AS development

COPY docker/php-fpm/php.ini /usr/local/etc/php/conf.d/zz-php-conf.ini

COPY docker/php-fpm/entrypoint.dev.sh /usr/local/bin/entrypoint.sh
COPY docker/php-fpm/entrypoint.common.sh /usr/local/bin/entrypoint.common.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.common.sh

USER fpm
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 9000
CMD ["php-fpm"]

FROM base AS production

# Install only runtime libraries needed in production
RUN apk add --no-cache \
  icu-libs \
  libjpeg-turbo \
  libpng \
  libwebp \
  freetype \
  libzip \
  zlib \
  fcgi \
  procps \
  oniguruma \
  openssl \
  mysql \
  mysql-client \
  \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Copy PHP extensions and libraries from the builder stage
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

# Install Composer dependencies
COPY composer.json composer.lock ./
RUN --mount=type=cache,target=/root/.composer \
  composer install \
  --no-dev \
  --optimize-autoloader \
  --classmap-authoritative \
  --no-interaction \
  --no-progress \
  --prefer-dist \
  && rm /usr/local/bin/composer

RUN rm -rf html
COPY . .
RUN rm -rf docker
COPY --from=skin-theme-final:latest /app/dist /var/www/web/app/themes/skin/dist/
RUN mkdir -p /var/www/web/app/uploads && chown -R fpm:fpm /var/www/web/app/uploads

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY docker/php-fpm/php.ini /usr/local/etc/php/conf.d/zz-php-conf.ini

COPY docker/php-fpm/entrypoint.prod.sh /usr/local/bin/entrypoint.sh
COPY docker/php-fpm/entrypoint.common.sh /usr/local/bin/entrypoint.common.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.common.sh

USER fpm
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 9000
CMD ["php-fpm"]
