<?php
declare(strict_types=1);

namespace MJEGenerator;

use function Amp\File\put;
use Generator;
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
     * @return Mount[]|Generator
     */
    private function collectMounts(): Generator
    {
        $bnet = new Battlenet($this->config['battle.net']['clientId'], $this->config['battle.net']['clientSecret']);

        $mounts = yield from $bnet->fetchMounts($bnet::REGION_EU);
        $mounts += yield from $bnet->fetchMounts($bnet::REGION_US);

        return $mounts;
    }

    /**
     * @param Mount[] $mounts
     * @return array
     */
    private function enhanceMounts($mounts)
    {
        $wowHead = new Wowhead($this->config['wowhead']['channel']);

        foreach ($this->config['missingMounts'] as $spellId => $mount) {
            if (false === isset($mounts[$spellId])) {
                $mounts[$spellId] = $mount;
            }
        }

        $mountItems = yield from $wowHead->fetchMountItems();
        foreach ($mountItems as $spellId => $itemIds) {
            if (isset($mounts[$spellId])) {
                $mounts[$spellId]->setItemIds($itemIds);
            }
        }
        foreach ($mounts as $mount) {
            $itemIds = $mount->getItemIds();
            if ([] !== $itemIds) {
                $tooltip = yield from $wowHead->fetchItemTooltip(reset($itemIds));
                if (false === empty($tooltip)
                    && false === strpos($tooltip, 'Binds when picked up')
                    && false === strpos($tooltip, 'Binds to Blizzard Battle.net account')
                ) {
                    $mount->setIsItemTradable(true);
                }
            }
        }

        foreach ($mounts as $mount) {
            $animations = yield from $wowHead->fetchAnimationsBySpellId($mount->getSpellId());
            foreach ($animations as $animation) {
                if ($animation->getName() === 'MountSpecial') {
                    $mount->setMountSpecialLength($animation->getLength());
                    break;
                }
            }
        }

        return $mounts;
    }

    private function generateFamilies(array $mounts): Generator
    {
        $wcmMountFamilies = (new WarcraftMounts)->fetchMountFamilies();

        $handler  = new Family($this->config['familyMap']);
        $families = $handler->groupMountsByFamily($mounts, $wcmMountFamilies);
        $lua      = $this->export->toLuaCategories('MountJournalEnhancedFamily', $families);
        yield put('families.db.lua', $lua);

        $errors = $handler->getErrors();
        if ([] !== $errors) {
            echo PHP_EOL . implode(PHP_EOL, $errors);
        }
    }

    private function generateMountSpecialList(array $mounts): Generator
    {
        $lua = $this->export->toLuaSpecialLength('MountJournalEnhancedMountSpecial', $mounts);
        yield put('mountspecial.db.lua', $lua);
    }
    private function generateTradableList(array $mounts): Generator
    {
        $lua = $this->export->toLuaTradable('MountJournalEnhancedTradable', $mounts);
        yield put('tradable.db.lua', $lua);
    }

    public function __invoke()
    {
        $mounts = yield from $this->collectMounts();
        $mounts = array_diff_key($mounts, array_flip($this->config['ignored']));
        $mounts = yield from $this->enhanceMounts($mounts);

        yield from $this->generateFamilies($mounts);
        yield from $this->generateMountSpecialList($mounts);
        yield from $this->generateTradableList($mounts);

        return $this;
    }
}