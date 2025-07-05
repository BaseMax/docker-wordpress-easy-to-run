<?php
$php = getenv('PHP_VERSION');
$ext = getenv('EXT_DIR');
$ioncubeJson = json_decode(file_get_contents('/tmp/ioncube.json'), true);
$sgJson = json_decode(file_get_contents('/tmp/sg.json'), true);

$ioncubeKey = $php . '_ts';
if (!isset($ioncubeJson[$ioncubeKey])) {
    $ioncubeKey = $php;
}
if (!isset($ioncubeJson[$ioncubeKey])) {
    fwrite(STDERR, 'No ionCube loader found for PHP ' . $php . PHP_EOL);
    exit(1);
}

$sgKey = $php . 'ts';
if (!isset($sgJson[$sgKey])) {
    $sgKey = $php;
}
if (!isset($sgJson[$sgKey])) {
    fwrite(STDERR, 'No SourceGuardian loader found for PHP ' . $php . PHP_EOL);
    exit(1);
}

file_put_contents('/tmp/ioncube.so', file_get_contents($ioncubeJson[$ioncubeKey]));
file_put_contents('/tmp/sg.so', file_get_contents($sgJson[$sgKey]));
