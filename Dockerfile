ARG PHP_VERSION=8.3
ARG COMPOSER_VERSION=2

FROM composer:${COMPOSER_VERSION} AS symfony_composer

FROM php:${PHP_VERSION}-fpm AS symfony_php

WORKDIR /srv/app

RUN set -eux; \
    apt-get update; apt-get install -y --no-install-recommends \
      acl \
      git \
      libxslt-dev \
      libzip-dev; \
    docker-php-ext-install intl xsl zip; \
    apt-get clean; rm -f /var/lib/apt/lists/*_*

COPY docker-symfony-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-symfony-entrypoint

RUN mkdir -p var/cache var/log
VOLUME /srv/app/var

COPY --from=symfony_composer /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN set -eux; \
    curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash; \
    apt-get install symfony-cli; \
    apt-get clean; rm -f /var/lib/apt/lists/*_*

ENTRYPOINT ["docker-symfony-entrypoint"]
CMD ["php-fpm"]
