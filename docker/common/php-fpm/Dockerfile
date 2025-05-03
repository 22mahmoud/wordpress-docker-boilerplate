FROM php:8.3-fpm-alpine AS base

ARG UID=1000
ARG GID=1000

RUN addgroup -g "${GID}" -S fpm \
  && adduser -u "${UID}" -G fpm -S -s /sbin/nologin fpm

RUN sed -i "s/user = www-data/user = fpm/g" /usr/local/etc/php-fpm.d/www.conf \
  && sed -i "s/group = www-data/group = fpm/g" /usr/local/etc/php-fpm.d/www.conf

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
  curl \
  git \
  unzip \
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

# Copy PHP config INI files
COPY docker/common/php-fpm/conf.d/opcache.ini /usr/local/etc/php/conf.d/
COPY docker/common/php-fpm/conf.d/uploads.ini /usr/local/etc/php/conf.d/
COPY docker/common/php-fpm/conf.d/zz-variables-order.ini /usr/local/etc/php/conf.d/

FROM builder AS development

COPY docker/dev/php-fpm/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

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
  oniguruma \
  openssl \
  \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Copy PHP extensions and libraries from the builder stage
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

# Install Composer and dependencies
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

COPY composer.json composer.lock ./
RUN composer install \
  --no-dev --optimize-autoloader --classmap-authoritative --no-interaction --no-progress --prefer-dist

COPY . .
RUN composer dump-autoload -o \
  && rm /usr/local/bin/composer

RUN chown -R fpm:fpm .

USER fpm
EXPOSE 9000
CMD ["php-fpm"]
