FROM composer AS install
WORKDIR /opt/project
ADD . .
RUN composer install


FROM php:7.3-cli-alpine

RUN apk --update --no-cache add autoconf g++ make && \
    pecl install xdebug && \
    apk del --purge autoconf g++ make

WORKDIR /opt/project
ADD . .
COPY --from=install /opt/project/vendor /opt/project/vendor

CMD php run.php