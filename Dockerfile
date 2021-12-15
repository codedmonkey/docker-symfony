ARG PHP_VERSION=8.1
ARG COMPOSER_VERSION=2

FROM composer:${COMPOSER_VERSION} AS symfony_composer

FROM php:${PHP_VERSION}-fpm AS symfony_php

WORKDIR /srv/app

COPY --from=symfony_composer /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

COPY --from=symfonycorp/cli /symfony /usr/bin/symfony
