#!/bin/sh

WP_CONTENT_DIR="/var/www/html/wp-content"
DIRS="uploads plugins themes mu-plugins"

if [ ! -d "$WP_CONTENT_DIR" ]; then
    echo "Creating wp-content..."
    mkdir -p "$WP_CONTENT_DIR"
fi

for dir in $DIRS; do
    if [ ! -d "$WP_CONTENT_DIR/$dir" ]; then
        echo "Creating $dir..."
        mkdir -p "$WP_CONTENT_DIR/$dir"
    fi
done

chown -R www-data:www-data "$WP_CONTENT_DIR"

find "$WP_CONTENT_DIR" -type d -exec chmod 755 {} \;

find "$WP_CONTENT_DIR" -type f -exec chmod 644 {} \;
