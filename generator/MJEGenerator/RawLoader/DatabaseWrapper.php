<?php

declare(strict_types=1);

namespace MJEGenerator\RawLoader;

use Erorus\DB2\HotfixedReader;
use Generator;

class DatabaseWrapper
{
    private $cacheFile;
    private $extractDir;

    private $creatureDisplayInfoReader;
    private $itemSparseReader;

    public function __construct(string $cacheDir, string $extractDir)
    {
        $this->cacheFile  = $cacheDir . '/ADB/enUS/DBCache.bin';
        $this->extractDir = $extractDir . '/dbfilesclient/';
    }

    public function iterateMount(): Generator
    {
        yield from $this->iterateFile(
            'Mount.db2',
            [
                'name',
                'sourceText',
                'description',
                'mountId',
                'mountTypeId',
                'flags',
                'sourceType',
                'spellId',
                'playerConditionId',
                'mountFlyRideHeight',
                'uiModelSceneId',
            ],
            [
                6 => true, //sourceType
            ]
        );
    }

    public function iterateMountXDisplay(): Generator
    {
        yield from $this->iterateFile(
            'MountXDisplay.db2',
            [
                'creatureDisplayId',
                'playerConditionId',
                'mountId',
            ]
        );
    }

    public function iterateSpellMisc(): Generator
    {
        yield from $this->iterateFile(
            'SpellMisc.db2',
            [
                'attributes',
                'difficultyId',
                'castingTimeIndex',
                'durationIndex',
                'rangeIndex',
                'schoolMask',
                'speed',
                'launchDelay',
                'minDuration',
                'iconFileId',
                'activeIconFileId',
                'field_8_2_0',
                'spellId',
            ]
        );
    }

    public function iterateItemEffect(): Generator
    {
        yield from $this->iterateFile(
            'ItemEffect.db2',
            [
                'legacySlotIndex',
                'triggerType',
                'charges',
                'coolDownMSec',
                'categoryCoolDownMSec',
                'spellCategoryId',
                'spellId',
                'chrSpecializationId',
                'itemId',
            ],
            [
                2 => true, //charges
                3 => true, //coolDownMSec
                4 => true, //categoryCoolDownMSec
            ]
        );
    }

    private function iterateFile(string $fileName, array $fieldNames, array $signedFields = []): Generator
    {
        $reader = new HotfixedReader($this->extractDir . $fileName, $this->cacheFile);
        $reader->setFieldNames($fieldNames);
        $reader->setFieldsSigned($signedFields);

        yield from $reader->generateRecords();
    }

    public function fetchCreatureDisplayInfo(int $creatureDisplayId): array
    {
        if (null === $this->creatureDisplayInfoReader) {
            $this->creatureDisplayInfoReader = new HotfixedReader($this->extractDir . 'CreatureDisplayInfo.db2', $this->cacheFile);
            $this->creatureDisplayInfoReader->setFieldNames([
                'modelId',
                'soundId',
                'sizeClass',
                // ... and a lot more
            ]);
        }

        return $this->creatureDisplayInfoReader->getRecord($creatureDisplayId);
    }

    public function fetchItemSparse(int $itemId): ?array
    {
        if (null === $this->itemSparseReader) {
            $this->itemSparseReader = new HotfixedReader($this->extractDir . 'ItemSparse.db2', $this->cacheFile);
            $this->itemSparseReader->setFieldNames([
                'AllowableRace',
                'Description_lang',
                'Display3_lang',
                'Display2_lang',
                'Display1_lang',
                'Display_lang',
                'DmgVariance',
                'DurationInInventory',
                'QualityModifier',
                'BagFamily',
                'ItemRange',
                'StatPercentageOfSocket',
                'StatPercentEditor',
                'Stackable',
                'MaxCount',
                'RequiredAbility',
                'SellPrice',
                'BuyPrice',
                'VendorStackCount',
                'PriceVariance',
                'PriceRandomValue',
                'Flags',
                'OppositeFactionItemID',
                'ItemNameDescriptionID',
                'RequiredTransmogHoliday',
                'RequiredHoliday',
                'LimitCategory',
                'Gem_properties',
                'Socket_match_enchantment_ID',
                'TotemCategoryID',
                'InstanceBound',
                'ZoneBound',
                'ItemSet',
                'LockID',
                'StartQuestID',
                'PageID',
                'ItemDelay',
                'ScalingStatDistributionID',
                'MinFactionID',
                'RequiredSkillRank',
                'RequiredSkill',
                'ItemLevel',
                'AllowableClass',
                'ExpansionID',
                'ArtifactID',
                'SpellWeight',
                'SpellWeightCategory',
                'SocketType',
                'SheatheType',
                'Material',
                'PageMaterialID',
                'LanguageID',
                'Bonding',
                'DamageType',
                'StatModifier_bonusStat',
                'ContainerSlots',
                'MinReputation',
                'RequiredPVPMedal',
                'RequiredPVPRank',
                'RequiredLevel',
                'InventoryType',
                'OverallQualityID',
            ]);
        }

        return $this->itemSparseReader->getRecord($itemId);
    }

}
