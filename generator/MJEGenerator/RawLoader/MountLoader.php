<?php

declare(strict_types=1);

namespace MJEGenerator\RawLoader;

use MJEGenerator\Mount;

class MountLoader
{

    private $dbWrapper;
    private $fileIdMapper;

    public function __construct(DatabaseWrapper $dbWrapper, FileIdMapper $fileIdMapper)
    {
        $this->dbWrapper    = $dbWrapper;
        $this->fileIdMapper = $fileIdMapper;
    }

    public function load(): array
    {
        $list = [];
        foreach ($this->dbWrapper->iterateMount() as $record) {
            $spellId        = (int) $record['SourceSpellID'];
            $list[$spellId] = new Mount($record['Name_lang'], $spellId);
        }

        foreach ($this->dbWrapper->iterateItemEffect() as $record) {
            if (1 === (int) $record['LegacySlotIndex'] && 6 === (int) $record['TriggerType'] && isset($list[$record['SpellID']])) {
                /** @var Mount $mount */
                $mount  = $list[$record['SpellID']];
                $itemId = (int) $record['ParentItemID'];

                $sparse = $this->dbWrapper->fetchItemSparse($itemId);
                if (null !== $sparse && 0 === (int) $sparse['Bonding']) {
                    $mount->setIsItemTradable(true);
                }
            }
        }

        foreach ($this->dbWrapper->iterateSpellMisc() as $record) {
            if (isset($list[$record['SpellID']])) {
                /** @var Mount $mount */
                $mount = $list[$record['SpellID']];
                $icon  = $this->fileIdMapper->fetchIcon((int) $record['SpellIconFileDataID']);
                $mount->setIcon($icon);
            }
        }

        return $list;
    }
}
