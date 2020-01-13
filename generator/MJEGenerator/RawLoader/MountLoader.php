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
            $spellId        = $record['SourceSpellID'];
            $list[$spellId] = new Mount($record['Name_lang'], $spellId);
        }

        foreach ($this->dbWrapper->iterateItemEffect() as $record) {
            if (1 === $record['LegacySlotIndex'] && 6 === $record['TriggerType'] && isset($list[$record['SpellID']])) {
                /** @var Mount $mount */
                $mount  = $list[$record['SpellID']];
                $itemId = $record['ParentItemID'];

                $sparse = $this->dbWrapper->fetchItemSparse($itemId);
                if (null !== $sparse && $sparse['Bonding'] === 0) {
                    $mount->setIsItemTradable(true);
                }
            }
        }

        foreach ($this->dbWrapper->iterateSpellMisc() as $record) {
            if (isset($list[$record['SpellId']])) {
                /** @var Mount $mount */
                $mount = $list[$record['SpellId']];
                $icon  = $this->fileIdMapper->fetchIcon($record['SpellIconFileDataID']);
                $mount->setIcon($icon);
            }
        }

        return $list;
    }
}
