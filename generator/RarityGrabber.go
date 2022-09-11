package main

import (
	"bytes"
	"encoding/json"
	"regexp"
)

func LoadRarities() map[int]*float32 {
	type json_mount struct {
		Slug      string
		Spell_id  int
		Id        int // some id of RR
		Name      string
		Ext_id    int      // mount id
		Sa_rarity *float32 // Rarity by RR
	}

	htmlBody := httpGet("https://rarityraider.com/en/mounts")
	reg := regexp.MustCompile(`data-page="({.*})"`)
	find := reg.FindSubmatch(htmlBody)
	data := bytes.Replace(find[1], []byte("&quot;"), []byte("\""), -1)

	var doc map[string]json.RawMessage
	err := json.Unmarshal(data, &doc)
	if err != nil {
		panic(err)
	}
	var props map[string]json.RawMessage
	err = json.Unmarshal(doc["props"], &props)
	if err != nil {
		panic(err)
	}
	var mounts []json_mount
	err = json.Unmarshal(props["mounts"], &mounts)
	if err != nil {
		panic(err)
	}

	result := map[int]*float32{}
	for _, mount := range mounts {
		if mount.Sa_rarity != nil {
			result[mount.Ext_id] = mount.Sa_rarity
		}
	}

	return result
}
