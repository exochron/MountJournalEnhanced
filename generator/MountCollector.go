package main

import (
	"mje_generator/condition"
	"regexp"
)

type mount struct {
	ID               int
	SpellID          int
	Name             string
	Icon             string
	ItemIsTradeable  bool
	PlayerConditions [][]condition.Condition
	Colors           [][]uint8
	Rarity           *float32
}

func (m *mount) AddColor(r, g, b uint8) {
	m.Colors = append(m.Colors, []uint8{r, g, b})
}

func ids_as_map(ids []int32) map[int32]int32 {
	m := make(map[int32]int32, len(ids))
	for _, id := range ids {
		m[id] = id
	}

	return m
}

func collectMounts(
	mountDB DBFile,
	playerConditionDB DBFile,
	itemSparseDB DBFile,
	itemEffectDB DBFile,
	itemXItemEffectDB DBFile,
	spellMiscDB DBFile,
	listfile map[int]string,
) map[int]*mount {
	mounts := map[int]*mount{}
	spellToMount := map[int]int{}

	for _, mountId := range mountDB.GetIDs() {
		id := int(mountId)
		spellId := int(mountDB.ReadInt(mountId, 7))
		playerConditionId := mountDB.ReadInt(mountId, 8)
		var mountConditions [][]condition.Condition
		if playerConditionId > 0 {
			mountConditions = condition.NewConditions(
				playerConditionDB.ReadInt64(playerConditionId, 0),
				playerConditionDB.ReadString(playerConditionId, 1),
				playerConditionDB.ReadInt(playerConditionId, 2),
				playerConditionDB.ReadInt(playerConditionId, 56),
			)
		}

		var colors [][]uint8
		mounts[id] = &mount{
			id,
			spellId,
			mountDB.ReadString(mountId, 0),
			"",
			false,
			mountConditions,
			colors,
			nil,
		}
		spellToMount[spellId] = id
	}

	itemSparseIDs := ids_as_map(itemSparseDB.GetIDs())
	for _, itemXItemEffectID := range itemXItemEffectDB.GetIDs() {
		effectID := itemXItemEffectDB.ReadInt(itemXItemEffectID, 0)
		itemID := itemXItemEffectDB.ReadInt(itemXItemEffectID, 1)
		spellID := int(itemEffectDB.ReadInt(effectID, 6))
		// is mount spell && is TriggerType = OnUse(6) && is Bonding = 0
		if mountID, ok := spellToMount[spellID]; ok && itemEffectDB.ReadInt(effectID, 1) == 6 {
			if _, ok := itemSparseIDs[itemID]; ok && itemSparseDB.ReadInt(itemID, 54) == 0 {
				mounts[mountID].ItemIsTradeable = true
			}
		}
	}

	regex := regexp.MustCompile(`interface/icons/(.*)\.blp`)
	for _, spellMiscID := range spellMiscDB.GetIDs() {
		spellID := spellMiscDB.ReadInt(spellMiscID, 15)
		if mountID, ok := spellToMount[int(spellID)]; ok {
			spellIconFileDataID := spellMiscDB.ReadInt(spellMiscID, 9)
			filePath := listfile[int(spellIconFileDataID)]
			find := regex.FindStringSubmatch(filePath)
			mounts[mountID].Icon = find[1]
		}
	}

	return mounts
}

type DBFile interface {
	GetIDs() []int32
	ReadInt(id int32, field int, array_index ...int) int32
	ReadInt64(id int32, field int) int64
	ReadString(id int32, field int) string
}
