<?php
declare(strict_types=1);

include 'vendor/autoload.php';
$config = include 'config.php';

\Amp\Loop::run(new \MJEGenerator\Runner($config));