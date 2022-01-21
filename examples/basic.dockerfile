FROM codedmonkey/symfony:8.0 AS app

COPY .env ./
#COPY .env.test phpunit.xml.dist ./
COPY composer.json composer.lock symfony.lock ./
COPY bin bin/
COPY config config/
#COPY migrations migrations/
COPY public public/
COPY src src/
COPY templates templates/
#COPY tests tests/
#COPY translations translations/

RUN composer install --no-dev --prefer-dist --no-autoloader --no-progress --no-scripts; \
    composer clear-cache; \
    composer dump-autoload --classmap-authoritative; \
    composer run-script post-install-cmd

FROM codedmonkey/symfony-nginx:latest AS http

COPY --from=app /srv/app/public public/
