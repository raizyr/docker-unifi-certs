FROM openjdk:8-alpine3.9


COPY rootfs /
RUN apk --no-cache add --update \
        bash=4.4.19-r1 \
        inotify-tools=3.20.1-r1 \
        libressl=2.7.5-r0 \
    && chmod +x /docker-entrypoint.sh \
    && ln -s /usr/lib/bashlib/bashlib /usr/bin/bashlib \
    # && apk del --purge .build-dependencies \
    && echo 'done'

WORKDIR /tmp
ENTRYPOINT ["/docker-entrypoint.sh"]

