<?php

declare(strict_types=1);

namespace MJEGenerator;

use GuzzleHttp\Client;
use MJEGenerator\Convert\Family;
use MJEGenerator\Convert\LuaExport;
use MJEGenerator\RawLoader\DatabaseWrapper;
use MJEGenerator\RawLoader\FileIdMapper;
use MJEGenerator\RawLoader\MountLoader;
use MJEGenerator\WarcraftMounts\Requester as WarcraftMounts;
use MJEGenerator\Wowhead\Requester as Wowhead;

class Runner
{
    private $config;

    public function __construct(array $config)
    {
        $this->config = $config;
    }

    private function loadRaw()
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

    /**
     * @param Mount[] $mounts
     *
     * @return Mount[]
     */
    private function enhanceMounts(array $mounts): array
    {
        $channel = $this->config['wowhead']['channel'];
        $guzzle  = new Client([
            'base_uri' => 'https://' . $channel . '.wowhead.com/',

            'retry_on_timeout'   => true,
            'max_retry_attempts' => 5,
        ]);

        $wowHead = new Wowhead($channel, $guzzle);

        $animations = $wowHead->fetchAnimationsForSpells(array_keys($mounts));
        foreach ($animations as $spellId => $animationList) {
            foreach ($animationList as $animation) {
                if ($animation->getName() === 'MountSpecial') {
                    $mounts[$spellId]->setMountSpecialLength($animation->getLength());
                    break;
                }
            }
        }

        return $mounts;
    }

    private function generateFamilies(array $mounts, LuaExport $export): self
    {
        $wcmMountFamilies = (new WarcraftMounts)->fetchMountFamilies();

        $handler  = new Family($this->config['familyMap']);
        $families = $handler->groupMountsByFamily($mounts, $wcmMountFamilies);
        $lua      = $export->toLuaCategories('MountJournalEnhancedFamily', $families);
        file_put_contents('families.db.lua', $lua);

        $errors = $handler->getErrors();
        if ([] !== $errors) {
            echo PHP_EOL . implode(PHP_EOL, $errors);
        }

        return $this;
    }

    private function generateMountSpecialList(array $mounts, LuaExport $export): self
    {
        $lua = $export->toLuaSpecialLength('MountJournalEnhancedMountSpecial', $mounts);
        file_put_contents('mountspecial.db.lua', $lua);

        return $this;
    }

    private function generateTradableList(array $mounts, LuaExport $export): self
    {
        $lua = $export->toLuaTradable('MountJournalEnhancedTradable', $mounts);
        file_put_contents('tradable.db.lua', $lua);

        return $this;
    }

    public function __invoke()
    {
        $mounts = $this->loadRaw();
        $mounts = array_diff_key($mounts, array_flip($this->config['ignored']));
        $mounts = $this->enhanceMounts($mounts);

        $export = new LuaExport();
        $this->generateFamilies($mounts, $export);
        $this->generateMountSpecialList($mounts, $export);
        $this->generateTradableList($mounts, $export);

        return $this;
    }
}
