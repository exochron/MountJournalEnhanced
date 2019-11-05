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
        $mountToSpellId = $list = [];
        foreach ($this->dbWrapper->iterateMount() as $record) {
            $spellId                  = $record['spellId'];
//            $mountId                  = $record['mountId'];
            $list[$spellId]           = new Mount($record['name'], $spellId);
//            $mountToSpellId[$mountId] = $spellId;
        }

//        foreach ($this->dbWrapper->iterateMountXDisplay() as $record) {
//            if (isset($mountToSpellId[$record['mountId']], $list[$mountToSpellId[$record['mountId']]])) {
//                /** @var Mount $mount */
//                $mount = $list[$mountToSpellId[$record['mountId']]];
//                $creatureInfo = $this->dbWrapper->fetchCreatureDisplayInfo($record['creatureDisplayId']);
//                $creatureInfo['modelId'];
//                var_dump($creatureInfo);
//            }
//        }

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
