<?php
$ioncubeUrl = "https://basemax.github.io/ioncube-loaders-linux-x86-64/data.json";
$sgUrl = "https://basemax.github.io/sourceguardian-loader-linux-x86-64/data.json";

$phpVersion = PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;
$extDir = ini_get('extension_dir');

$ioncubeJson = json_decode(file_get_contents($ioncubeUrl), true);
$sgJson = json_decode(file_get_contents($sgUrl), true);

if (json_last_error() !== JSON_ERROR_NONE) {
    fwrite(STDERR, 'Failed to parse JSON from URLs' . PHP_EOL);
    exit(1);
}

$ioncubeKey = $phpVersion;
if (!isset($ioncubeJson[$ioncubeKey])) {
    fwrite(STDERR, 'No ionCube loader found for PHP ' . $phpVersion . PHP_EOL);
    exit(1);
}

$sgKey = $phpVersion;
if (!isset($sgJson[$sgKey])) {
    fwrite(STDERR, 'No SourceGuardian loader found for PHP ' . $phpVersion . PHP_EOL);
    exit(1);
}

if (!file_put_contents('/tmp/ioncube.so', file_get_contents($ioncubeJson[$ioncubeKey]))) {
    fwrite(STDERR, 'Failed to download or save ionCube loader' . PHP_EOL);
    exit(1);
}

if (!file_put_contents('/tmp/sg.so', file_get_contents($sgJson[$sgKey]))) {
    fwrite(STDERR, 'Failed to download or save SourceGuardian loader' . PHP_EOL);
    exit(1);
}

$ioncubeDest = "$extDir/ioncube_loader_lin_$phpVersion.so";
$sgDest = "$extDir/ixed.$phpVersion.lin";

if (!rename('/tmp/ioncube.so', $ioncubeDest)) {
    fwrite(STDERR, 'Failed to move ionCube loader to ' . $ioncubeDest . PHP_EOL);
    exit(1);
}

if (!rename('/tmp/sg.so', $sgDest)) {
    fwrite(STDERR, 'Failed to move SourceGuardian loader to ' . $sgDest . PHP_EOL);
    exit(1);
}

$ioncubeIni = "/usr/local/etc/php/conf.d/00-ioncube.ini";
$sgIni = "/usr/local/etc/php/conf.d/00-sourceguardian.ini";

if (!file_put_contents($ioncubeIni, "zend_extension=$ioncubeDest" . PHP_EOL)) {
    fwrite(STDERR, 'Failed to create ionCube configuration file' . PHP_EOL);
    exit(1);
}

if (!file_put_contents($sgIni, "zend_extension=$sgDest" . PHP_EOL)) {
    fwrite(STDERR, 'Failed to create SourceGuardian configuration file' . PHP_EOL);
    exit(1);
}
