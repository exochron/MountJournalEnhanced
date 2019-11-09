FROM php:7.3-cli-alpine

RUN apk --update --no-cache add gmp-dev && \
    docker-php-ext-install -j$(nproc) gmp

RUN apk --update --no-cache add autoconf g++ make && \
    pecl install xdebug && \
    apk del --purge autoconf g++ make

WORKDIR /app
ADD . .
COPY php.ini /usr/local/etc/php/conf.d/custom.ini

ENV COMPOSER_ALLOW_SUPERUSER 1
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN composer install

CMD php run.php