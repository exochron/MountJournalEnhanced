<?php

declare(strict_types=1);

namespace MJEGenerator;

use MJEGenerator\Convert\Family;
use MJEGenerator\Convert\LuaExport;
use MJEGenerator\RawLoader\DatabaseWrapper;
use MJEGenerator\RawLoader\FileIdMapper;
use MJEGenerator\RawLoader\MountLoader;
use MJEGenerator\WarcraftMounts\Requester;

class Runner
{
    private $config;

    public function __construct(array $config)
    {
        $this->config = $config;
    }

    private function loadRaw(): array
    {
        $fileIdMapper = new FileIdMapper('raw/listfile.csv');

        $loader = new MountLoader(
            new DatabaseWrapper('raw/Cache', 'raw/Extract'),
            $fileIdMapper
        );
        $mounts = $loader->load();

        ksort($mounts);

        return $mounts;
    }

    private function generateFamilies(array $mounts, LuaExport $export): self
    {
        $wcmMountFamilies = (new Requester)->fetchMountFamilies();

        $handler  = new Family($this->config['familyMap']);
        $families = $handler->groupMountsByFamily($mounts, $wcmMountFamilies);
        $lua      = $export->toLuaCategories('Family', $families);
        file_put_contents('families.db.lua', $lua);

        $errors = $handler->getErrors();
        if ([] !== $errors) {
            echo PHP_EOL . implode(PHP_EOL, $errors);
        }

        return $this;
    }

    private function generateTradableList(array $mounts, LuaExport $export): self
    {
        $lua = $export->toLuaTradable('Tradable', $mounts);
        file_put_contents('tradable.db.lua', $lua);

        return $this;
    }

    public function __invoke()
    {
        $mounts = $this->loadRaw();
        $mounts = array_diff_key($mounts, array_flip($this->config['ignored']));

        $export = new LuaExport();
        $this->generateFamilies($mounts, $export);
        $this->generateTradableList($mounts, $export);

        return $this;
    }
}
