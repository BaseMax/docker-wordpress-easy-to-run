ARG PHP_VERSION=8.1

FROM wordpress:php${PHP_VERSION}-apache

COPY setup-loaders.php /tmp/setup-loaders.php

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libudev-dev \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    php /tmp/setup-loaders.php; \
    rm /tmp/setup-loaders.php

COPY setup-wp-content.sh /usr/local/bin/setup-wp-content.sh
RUN chmod +x /usr/local/bin/setup-wp-content.sh && /usr/local/bin/setup-wp-content.sh
