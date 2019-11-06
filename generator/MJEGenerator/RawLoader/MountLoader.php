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
            $spellId        = $record['spellId'];
            $list[$spellId] = new Mount($record['name'], $spellId);
        }

        foreach ($this->dbWrapper->iterateItemEffect() as $record) {
            if (1 === $record['legacySlotIndex'] && 6 === $record['triggerType'] && isset($list[$record['spellId']])) {
                /** @var Mount $mount */
                $mount  = $list[$record['spellId']];
                $itemId = $record['itemId'];

                $sparse = $this->dbWrapper->fetchItemSparse($itemId);
                if (null !== $sparse && $sparse['Bonding'] === 0) {
                    $mount->setIsItemTradable(true);
                }
            }
        }

        foreach ($this->dbWrapper->iterateSpellMisc() as $record) {
            if (isset($list[$record['spellId']])) {
                /** @var Mount $mount */
                $mount = $list[$record['spellId']];
                $icon  = $this->fileIdMapper->fetchIcon($record['iconFileId']);
                $mount->setIcon($icon);
            }
        }

        return $list;
    }
}
