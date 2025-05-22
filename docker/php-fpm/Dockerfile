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
  # gd & imagemagick support
  libjpeg-turbo-dev \
  libpng-dev \
  libwebp-dev \
  freetype-dev \
  imagemagick-dev \
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
  # phpredis
  && pecl install redis \
  && docker-php-ext-enable redis \
  \
  # Install imagick PHP extension
  && pecl install imagick \
  && docker-php-ext-enable imagick \
  \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*


FROM builder AS development

# Install Xdebug
RUN apk add --no-cache linux-headers \
  && pecl install xdebug \
  && docker-php-ext-enable xdebug

COPY docker/php-fpm/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY docker/php-fpm/php.ini /usr/local/etc/php/conf.d/zz-php-conf.ini

COPY docker/php-fpm/entrypoint.dev.sh /usr/local/bin/entrypoint.sh
COPY docker/php-fpm/entrypoint.common.sh /usr/local/bin/entrypoint.common.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.common.sh

USER fpm
ENTRYPOINT ["entrypoint.sh"]
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
  imagemagick \
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
  --prefer-dist


RUN rm -rf html
COPY . .
RUN rm -rf docker
RUN composer dump-autoload -o \
  && rm /usr/local/bin/composer

COPY --from=ghcr.io/22mahmoud/frontend-final:latest /app/web/app/themes/skin/dist /var/www/web/app/themes/skin/dist/
COPY --from=ghcr.io/22mahmoud/frontend-final:latest /app/web/app/plugins/blocks/build /var/www/web/app/plugins/blocks/build/

RUN mkdir -p /var/www/web/app/uploads

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY docker/php-fpm/php.ini /usr/local/etc/php/conf.d/zz-php-conf.ini

COPY docker/php-fpm/entrypoint.prod.sh /usr/local/bin/entrypoint.sh
COPY docker/php-fpm/entrypoint.common.sh /usr/local/bin/entrypoint.common.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.common.sh

RUN chown -R fpm:fpm .

USER fpm
ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]
