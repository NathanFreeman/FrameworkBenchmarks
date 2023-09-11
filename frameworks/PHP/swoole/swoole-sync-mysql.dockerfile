FROM ubuntu:22.04

ENV PHP_VERSION 8.2.10
ENV SWOOLE_VERSION 5.0.3
ENV ENABLE_COROUTINE 0
ENV DATABASE_DRIVER mysql

RUN apt update && apt install -y autoconf re2c bison gcc g++ libxml2-dev pkg-config libsqlite3-dev libssl-dev libpq-dev zlib1g-dev make curl && \
cd /tmp && \
curl -sSL "https://github.com/php/php-src/archive/refs/tags/php-${PHP_VERSION}.tar.gz" | tar xzf -  && \
curl -sSL "https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz" | tar xzf -  && \
ln -s /tmp/swoole-src-${SWOOLE_VERSION} /tmp/php-src-php-${PHP_VERSION}/ext/swoole && \
cd /tmp/php-src-php-${PHP_VERSION}/ && ./buildconf --force && \
./configure --prefix=/tmp/php/ --with-pdo-pgsql --with-pdo-mysql --enable-swoole --enable-swoole-pgsql --enable-openssl  && make -j2 && make install  && \
ln -s /tmp/php/bin/php /usr/bin/php

COPY php.ini /tmp/php/lib/

WORKDIR /swoole

COPY swoole-server.php swoole-server.php
EXPOSE 8080
CMD php swoole-server.php