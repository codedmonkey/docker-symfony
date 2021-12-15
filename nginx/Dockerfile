FROM nginx:latest AS nginx

WORKDIR /srv/app

ENV FPM_HOST=app
ENV FPM_PORT=9000

RUN rm /etc/nginx/conf.d/default.conf
COPY templates/app.conf.template /etc/nginx/templates/
