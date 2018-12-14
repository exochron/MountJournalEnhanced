<?php
declare(strict_types=1);

namespace MJEGenerator;

use MJEGenerator\Battlenet\Requester as Battlenet;
use MJEGenerator\Wowhead\Requester as Wowhead;
use MJEGenerator\WarcraftMounts\Requester as WarcraftMounts;
use MJEGenerator\Convert\Family;
use MJEGenerator\Convert\LuaExport;

class Runner
{
    private $config;
    private $export;

    public function __construct(array $config)
    {
        $this->config = $config;
        $this->export = new LuaExport;
    }

    /**
     * @return Mount[]
     */
    private function collectMounts(): array
    {
        $bnet = new Battlenet($this->config['battle.net']['clientId'], $this->config['battle.net']['clientSecret']);

        return $bnet->fetchMounts($bnet::REGION_EU) + $bnet->fetchMounts($bnet::REGION_US);
    }

    /**
     * @param Mount[] $mounts
     * @return array
     */
    private function enhanceMounts($mounts): array
    {
        $wowHead = new Wowhead;

        foreach ($this->config['missingMounts'] as $spellId => $mount) {
            if (false === isset($mounts[$spellId])) {
                $mounts[$spellId] = $mount;
            }
        }

//        $mountItems = $wowHead->fetchMountItems();
//        foreach ($mountItems as $spellId => $itemIds) {
//            if (isset($mounts[$spellId])) {
//                $mounts[$spellId]->setItemIds($itemIds);
//            }
//        }

        foreach ($mounts as $mount) {
            $animations = $wowHead->fetchAnimationsBySpellId($mount->getSpellId());
            foreach ($animations as $animation) {
                if ($animation->getName() === 'MountSpecial') {
                    $mount->setMountSpecialLength($animation->getLength());
                    break;
                }
            }
        }

        return $mounts;
    }

    private function generateFamilies(array $mounts): self
    {
        $wcmMountFamilies = (new WarcraftMounts)->fetchMountFamilies();

        $handler  = new Family($this->config['familyMap']);
        $families = $handler->groupMountsByFamily($mounts, $wcmMountFamilies);
        $lua      = $this->export->toLuaCategories('MountJournalEnhancedFamily', $families);
        file_put_contents('families.db.lua', $lua);

        $errors = $handler->getErrors();
        if ([] !== $errors) {
            echo PHP_EOL . implode(PHP_EOL, $errors);
        }

        return $this;
    }

    private function generateMountSpecialList(array $mounts): self
    {
        $lua = $this->export->toLuaSpecialLength('MountJournalEnhancedMountSpecial', $mounts);
        file_put_contents('mountspecial.db.lua', $lua);

        return $this;
    }

    public function run(): self
    {
        $mounts = $this->collectMounts();
        $mounts = array_diff_key($mounts, array_flip($this->config['ignored']));
        $mounts = $this->enhanceMounts($mounts);

        $this->generateFamilies($mounts);
        $this->generateMountSpecialList($mounts);

        return $this;
    }
}