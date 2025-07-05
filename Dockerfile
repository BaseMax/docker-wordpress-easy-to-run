ARG PHP_VERSION=8.1

FROM wordpress:php${PHP_VERSION}-fpm-alpine

COPY setup-loaders.php /tmp/setup-loaders.php

RUN apk add --no-cache libudev-zero

RUN set -eux; \
    php /tmp/setup-loaders.php; \
    rm /tmp/setup-loaders.php

COPY setup-wp-content.sh /usr/local/bin/setup-wp-content.sh
RUN chmod +x /usr/local/bin/setup-wp-content.sh

CMD ["sh", "-c", "/usr/local/bin/setup-wp-content.sh && docker-entrypoint.sh php-fpm"]
