FROM ubuntu:24.04

ENV ENABLE_COROUTINE 0
ENV DATABASE_DRIVER pgsql

RUN cd /tmp \
    && curl -sSL "https://github.com/swoole/swoole-cli/releases/download/v5.1.3.0/swoole-cli-v5.1.3-linux-x64.tar.xz" | tar xf - \
    && chmod 0755 ./swoole-cli

WORKDIR /swoole

ADD ./swoole-server.php /swoole
ADD ./database.php /swoole

EXPOSE 8080
CMD /tmp/swoole-cli \
    -dopcache.enable=1 \
    -dopcache.enable_cli=1  \
    -dopcache.validate_timestamps=0 \
    -dopcache.enable_file_override=1 \
    -dopcache.huge_code_pages=1 \
    -dmemory_limit=1024M \
    -dopcache.jit_buffer_size=128M \
    -dopcache.jit=1225 \
    /swoole/swoole-server.php
