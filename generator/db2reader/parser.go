package db2reader

import (
	"bytes"
	"sort"
)

type section_entry struct {
	section_number int
	section_index  int
	total_position int
}

type wdc3_source struct {
	source WDC3
	fields []field_preparation
	id_map map[int32]section_entry
}

const (
	source_section_data = 1
	source_common       = 2
	source_pallet       = 3
)

type field_preparation struct {
	start_byte     int
	bit_offset     int
	bit_mask       int
	array_size     int
	payload_source int
	default_value  int32
	common_map     map[int32]int32
	pallet_offset  int
}

func bytes_as_int32(data []byte) int32 {
	var value int32 = int32(data[0])
	value |= (int32(data[1]) << 8)
	value |= (int32(data[2]) << 16)
	value |= (int32(data[3]) << 24)
	return value
}

func bytes_as_int64(data []byte) int64 {
	var value int64 = int64(data[0])
	value |= (int64(data[1]) << 8)
	value |= (int64(data[2]) << 16)
	value |= (int64(data[3]) << 24)
	value |= (int64(data[4]) << 32)
	value |= (int64(data[5]) << 40)
	value |= (int64(data[6]) << 48)
	value |= (int64(data[7]) << 56)
	return value
}

func (f field_preparation) read_from(data []byte) int32 {
	start := f.start_byte
	var value int32 = bytes_as_int32(data[start : start+4])

	value >>= int32(f.bit_offset)
	value &= int32(f.bit_mask)

	return value
}

func (w wdc3_source) fetch_record(entry section_entry) []byte {
	section := w.source.Sections[entry.section_number]
	if entry.section_index < len(section.records) {
		return section.records[entry.section_index]
	}

	section_head := w.source.SectionHeaders[entry.section_number]
	offset := section.offset_map[entry.section_index]
	start := offset.offset
	start -= section_head.file_offset

	return section.variable_record_data[start:(start + uint32(offset.size))]
}

func prepareWDC3(w WDC3) wdc3_source {

	obj := wdc3_source{}
	obj.source = w
	obj.fields = make([]field_preparation, w.Header.field_count)

	common_offset := 0
	pallet_offset := 0
	for i := 0; i < int(w.Header.field_count); i++ {
		storage := w.FieldStorage[i]
		prep := field_preparation{}
		prep.array_size = 1
		prep.start_byte = int(w.FieldStructures[i].position)
		prep.bit_offset = int(storage.field_offset_bits) - prep.start_byte*8
		prep.start_byte += int(prep.bit_offset / 8)
		prep.bit_offset %= 8

		prep.bit_mask = 0
		for i := 0; i < int(storage.field_size_bits); i++ {
			prep.bit_mask <<= 1
			prep.bit_mask |= 1
		}

		payload_size := int(storage.additional_data_size)
		if w.FieldStructures[i].size == 0 && storage.storage_type == 0 {
			prep.payload_source = source_section_data
		} else if storage.storage_type == 2 {
			prep.payload_source = source_common
			prep.default_value = int32(storage.extra_1)

			prep.common_map = make(map[int32]int32, payload_size/8)
			for i := common_offset; i < common_offset+payload_size; i = i + 8 {
				id := bytes_as_int32(w.CommonData[i : i+4])
				prep.common_map[id] = bytes_as_int32(w.CommonData[i+4 : i+8])
			}
			common_offset += payload_size
		} else if storage.storage_type == 3 || storage.storage_type == 4 {
			prep.payload_source = source_pallet
			prep.pallet_offset = pallet_offset
			pallet_offset += payload_size
			if storage.storage_type == 4 {
				prep.array_size = int(storage.extra_3)
			}
		}

		obj.fields[i] = prep
	}

	id_definition := obj.fields[w.Header.id_index]
	obj.id_map = make(map[int32]section_entry)
	position := 0
	for sid := 0; sid < int(w.Header.section_count); sid++ {
		section := w.Sections[sid]
		if len(section.id_list) > 0 {
			for sindex := 0; sindex < len(section.id_list); sindex++ {
				obj.id_map[int32(section.id_list[sindex])] = section_entry{sid, sindex, position}
				position++
			}
		} else {
			for sindex, record := range section.records {
				id := id_definition.read_from(record)
				if id > 0 {
					obj.id_map[id] = section_entry{sid, sindex, position}
				}
				position++
			}
		}

		for _, copy_entry := range section.copy_table {
			obj.id_map[int32(copy_entry.id_of_new_row)] = obj.id_map[int32(copy_entry.id_of_copied_row)]
		}
	}

	return obj
}

func (w wdc3_source) ReadString(id int32, field int) string {
	field_info := w.fields[field]
	entry := w.id_map[id]
	record := w.source.Sections[entry.section_number].records[entry.section_index]
	string_offset := field_info.read_from(record)

	string_offset -= int32(w.source.Header.record_size) * (int32(w.source.Header.record_count) - int32(entry.total_position))
	string_offset += int32(field_info.start_byte)

	var payload []byte
	for sid, sectionHeader := range w.source.SectionHeaders {
		if string_offset < int32(sectionHeader.string_table_size) {
			payload = w.source.Sections[sid].string_data
			break
		}

		string_offset -= int32(sectionHeader.string_table_size)
	}

	end := bytes.IndexByte(payload[string_offset:], 0)
	return string(payload[string_offset:(int(string_offset) + end)])
}

func (w wdc3_source) ReadInt(id int32, field int) int32 {
	var value int32

	entry := w.id_map[id]
	section := w.source.Sections[entry.section_number]

	if field < len(w.fields) {
		record := w.fetch_record(entry)
		field_info := w.fields[field]

		if len(section.offset_map) > 0 {
			// variable record of ItemSparse
			string_fields := 5         // has 5 variable string fields in front
			slice_n_dice := record[8:] // also starts with 64bit field
			// wen now calculate the diff bweteen the combined string lengths and the field definitions
			variable_offset := string_fields - (string_fields * 4) // (count of zero byte for each string) - (each string is defined as 32bit field)
			for i := 0; i < string_fields; i++ {
				pos := bytes.IndexByte(slice_n_dice, 0)
				variable_offset += pos
				slice_n_dice = slice_n_dice[pos+1:]
			}
			value = field_info.read_from(record[variable_offset:])
		} else {
			value = field_info.read_from(record)
		}

		if field_info.payload_source == source_pallet {
			value *= int32(4 * field_info.array_size)
			value += int32(field_info.pallet_offset)
			value = bytes_as_int32(w.source.PalletData[value : value+4])
		} else if field_info.payload_source == source_common {
			common_value, ok := field_info.common_map[id]
			if ok {
				value = common_value
			} else {
				value = field_info.default_value
			}
		}
	} else if entry.section_index < len(section.relationship_map.entries) {
		value = int32(section.relationship_map.entries[entry.section_index].foreign_id)
	}

	return value
}

func (w wdc3_source) ReadInt64(id int32, field int) int64 {
	field_info := w.fields[field]
	entry := w.id_map[id]
	record := w.fetch_record(entry)
	return bytes_as_int64(record[field_info.start_byte : field_info.start_byte+8])
}

func (w wdc3_source) GetIDs() []int32 {
	keys := make([]int32, 0, len(w.id_map))
	for k := range w.id_map {
		keys = append(keys, k)
	}

	sort.Slice(keys, func(i, j int) bool {
		return i < j
	})

	return keys
}
