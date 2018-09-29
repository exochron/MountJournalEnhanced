<?php
declare(strict_types=1);

$source    = new RecursiveDirectoryIterator('MJEGenerator');
$recursive = new RecursiveIteratorIterator($source);
$filter    = new RegexIterator($recursive, '/^.+\.php$/i', RecursiveRegexIterator::GET_MATCH);

foreach ($filter as $file) {
    include $file[0];
}