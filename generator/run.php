<?php
declare(strict_types=1);

include "autoload.php";
$config = include "config.php";

(new \MJEGenerator\Runner($config))->run();