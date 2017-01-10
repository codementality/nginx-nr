FROM debian:jessie

MAINTAINER Lisa Ridley "lhridley@gmail.com"

ENV NGINX_VERSION 1.10.2-1~jessie

RUN apt-get update && apt-get install curl ca-certificates --no-install-recommends --no-install-suggests -y \
    && curl -O https://nginx.org/keys/nginx_signing.key && apt-key add ./nginx_signing.key

RUN echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
						ca-certificates \
						nginx=${NGINX_VERSION} \
						nginx-module-xslt \
						nginx-module-geoip \
						nginx-module-image-filter \
						nginx-module-perl \
						nginx-module-njs \
						gettext-base \
	&& rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
    && touch /var/run/nginx.pid \
    && chown -R www-data:www-data /var/run/nginx.pid \
    && chown -R www-data:www-data /var/cache/nginx \
    && touch /var/run/nginx.pid \
    && chown -R www-data:www-data /var/run/nginx.pid \
    && chown -R www-data:www-data /var/cache/nginx

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf /etc/nginx/conf.d/default.conf

RUN chown -Rf www-data:www-data /etc/nginx

EXPOSE 8080 8443

USER www-data

VOLUME /var/www

CMD ["nginx", "-g", "daemon off;"]
