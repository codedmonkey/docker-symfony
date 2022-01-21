# Symfony Docker Images

Docker images optimized for use with the [Symfony][symfony] PHP framework.

## How to use these images in your Symfony project

Create a `Dockerfile` file in your Symfony project

```dockerfile
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
```

Create a `docker-compose.yaml` file in your Symfony project

```yaml
version: "3.8"

services:
  app:
    build:
      context: .
      target: app
    tty: true
    # Uncomment this line to fall back on the PHP image entrypoint
    #entrypoint: docker-php-entrypoint
    volumes:
      - ./:/srv/app

  http:
    build:
      context: .
      target: http
    ports:
      - "8000:80"
    volumes:
      - ./:/srv/app
```

Then, run the commands to build and run the Docker images

```shell
docker compose build
docker compose up -d
```

## Disclaimer

This project is not affiliated with Symfony, or it's parent company SensioLabs.

[symfony]: https://www.symfony.com
