<?php
include "autoload.php";
$config = include "config.php";

(new \MJEGenerator\Runner($config))->run();