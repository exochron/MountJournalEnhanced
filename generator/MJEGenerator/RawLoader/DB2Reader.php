<?php

declare(strict_types=1);

namespace MJEGenerator\RawLoader;

use Erorus\DB2\HotfixedReader;
use Generator;

class DB2Reader
{
    private $cacheFile;
    private $extractDir;

    private $itemSparseReader;

    public function __construct(string $cacheDir, string $extractDir)
    {
        $this->cacheFile  = $cacheDir . '/ADB/enUS/DBCache.bin';
        $this->extractDir = $extractDir;
    }

    public function iterateMount(): Generator
    {
        yield from $this->iterateFile(
            'Mount.db2',
            [
                'Name_lang',
                'SourceText_lang',
                'Description_lang',
                'ID',
                'MountTypeID',
                'Flags',
                'SourceTypeEnum',
                'SourceSpellID',
                'PlayerConditionID',
                'MountFlyRideHeight',
                'UiModelSceneID',
                'Field_8_3_0_32272_011',
                'Field_8_3_0_32712_012',
            ],
            [
                6 => true, //sourceType
            ]
        );
    }

    public function iterateSpellMisc(): Generator
    {
        yield from $this->iterateFile(
            'SpellMisc.db2',
            [
                'Attributes',
                'DifficultyID',
                'CastingTimeIndex',
                'DurationIndex',
                'RangeIndex',
                'SchoolMask',
                'Speed',
                'LaunchDelay',
                'MinDuration',
                'SpellIconFileDataID',
                'ActiveIconFileDataID',
                'Field_8_2_0_30827_010',
                'SpellID',
            ]
        );
    }

    public function iterateItemEffect(): Generator
    {
        yield from $this->iterateFile(
            'ItemEffect.db2',
            [
                'LegacySlotIndex',
                'TriggerType',
                'Charges',
                'CoolDownMSec',
                'CategoryCoolDownMSec',
                'SpellCategoryID',
                'SpellID',
                'ChrSpecializationID',
                'ParentItemID',
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
