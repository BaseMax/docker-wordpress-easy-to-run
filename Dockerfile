FROM wordpress:php8.1-fpm-alpine

ENV IONCUBE_JSON_URL="https://basemax.github.io/ioncube-loaders-linux-x86-64/data.json"
ENV SG_JSON_URL="https://basemax.github.io/sourceguardian-loader-linux-x86-64/data.json"

RUN set -eux; \
  PHP_VERSION="$(php -r 'echo PHP_MAJOR_VERSION . "." . PHP_MINOR_VERSION;')"; \
  EXT_DIR="$(php -r 'echo ini_get("extension_dir");')"; \
  php -r "
  phpinfo();
    $php = getenv('PHP_VERSION');
    $ext = getenv('EXT_DIR');
    $ioncubeJson = json_decode(file_get_contents(getenv('IONCUBE_JSON_URL')), true);
    $sgJson = json_decode(file_get_contents(getenv('SG_JSON_URL')), true);

    $ioncubeKey = $php . '_ts';
    if (!isset($ioncubeJson[$ioncubeKey])) {
        $ioncubeKey = $php;
    }
    if (!isset($ioncubeJson[$ioncubeKey])) {
        fwrite(STDERR, 'No ionCube loader found for PHP $php' . PHP_EOL);
        exit(1);
    }

    $sgKey = $php . 'ts';
    if (!isset($sgJson[$sgKey])) {
        $sgKey = $php;
    }
    if (!isset($sgJson[$sgKey])) {
        fwrite(STDERR, 'No SourceGuardian loader found for PHP $php' . PHP_EOL);
        exit(1);
    }

    copy($ioncubeJson[$ioncubeKey], $ext . '/ioncube_loader_lin_' . $php . '.so');
    copy($sgJson[$sgKey], $ext . '/ixed.' . $php . '.lin');

    file_put_contents('/usr/local/etc/php/conf.d/00-ioncube.ini', 'zend_extension=$ext/ioncube_loader_lin_$php.so' . PHP_EOL);
    file_put_contents('/usr/local/etc/php/conf.d/00-sourceguardian.ini', 'zend_extension=$ext/ixed.$php.lin' . PHP_EOL);
  ";

COPY setup-wp-content.sh /usr/local/bin/setup-wp-content.sh
RUN chmod +x /usr/local/bin/setup-wp-content.sh

CMD ["sh", "-c", "/usr/local/bin/setup-wp-content.sh && docker-entrypoint.sh php-fpm"]
