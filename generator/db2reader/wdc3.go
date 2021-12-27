package db2reader

// https://wowdev.wiki/DB2#WDC3

type WDC3 struct {
	Header          wdc3_header
	SectionHeaders  []wdc3_section_header
	FieldStructures []field_structure
	FieldStorage    []field_storage_info
	PalletData      []byte
	CommonData      []byte
	Sections        []section
}

type wdc3_header struct {
	magic                   string // 'WDC3'
	record_count            uint32 // this is for all sections combined now
	field_count             uint32
	record_size             uint32
	string_table_size       uint32 // this is for all sections combined now
	table_hash              uint32 // hash of the table name
	layout_hash             uint32 // this is a hash field that changes only when the structure of the data changes
	min_id                  uint32
	max_id                  uint32
	locale                  uint32 // as seen in TextWowEnum
	flags                   uint16 // possible values are listed in Known Flag Meanings
	id_index                uint16 // this is the index of the field containing ID values this is ignored if flags & 0x04 != 0
	total_field_count       uint32 // from WDC1 onwards, this value seems to always be the same as the 'field_count' value
	bitpacked_data_offset   uint32 // relative position in record where bitpacked data begins not important for parsing the file
	lookup_column_count     uint32
	field_storage_info_size uint32
	common_data_size        uint32
	pallet_data_size        uint32
	section_count           uint32 // new to WDC2, this is number of sections of data
}

func (h *wdc3_header) Read(br *ByteReader) {
	h.magic = br.ReadString(4)
	h.record_count = br.ReadUInt32()
	h.field_count = br.ReadUInt32()
	h.record_size = br.ReadUInt32()
	h.string_table_size = br.ReadUInt32()
	h.table_hash = br.ReadUInt32()
	h.layout_hash = br.ReadUInt32()
	h.min_id = br.ReadUInt32()
	h.max_id = br.ReadUInt32()
	h.locale = br.ReadUInt32()
	h.flags = br.ReadUInt16()
	h.id_index = br.ReadUInt16()
	h.total_field_count = br.ReadUInt32()
	h.bitpacked_data_offset = br.ReadUInt32()
	h.lookup_column_count = br.ReadUInt32()
	h.field_storage_info_size = br.ReadUInt32()
	h.common_data_size = br.ReadUInt32()
	h.pallet_data_size = br.ReadUInt32()
	h.section_count = br.ReadUInt32()
}

type wdc3_section_header struct {
	tact_key_hash          uint64 // TactKeyLookup hash
	file_offset            uint32 // absolute position to the beginning of the section
	record_count           uint32 // 'record_count' for the section
	string_table_size      uint32 // 'string_table_size' for the section
	offset_records_end     uint32 // Offset to the spot where the records end in a file with an offset map structure;
	id_list_size           uint32 // Size of the list of ids present in the section
	relationship_data_size uint32 // Size of the relationship data in the section
	offset_map_id_count    uint32 // Count of ids present in the offset map in the section
	copy_table_count       uint32 // Count of the number of deduplication entries (you can multiply by 8 to mimic the old 'copy_table_size' field)
}

func (h *wdc3_section_header) Read(br *ByteReader) {
	h.tact_key_hash = br.ReadUInt64()
	h.file_offset = br.ReadUInt32()
	h.record_count = br.ReadUInt32()
	h.string_table_size = br.ReadUInt32()
	h.offset_records_end = br.ReadUInt32()
	h.id_list_size = br.ReadUInt32()
	h.relationship_data_size = br.ReadUInt32()
	h.offset_map_id_count = br.ReadUInt32()
	h.copy_table_count = br.ReadUInt32()
}

type field_structure struct {
	size     int16  // size in bits as calculated by: byteSize = (32 - size) / 8; this value can be negative to indicate field sizes larger than 32-bits
	position uint16 // position of the field within the record, relative to the start of the record
}

func (f *field_structure) Read(br *ByteReader) {
	f.size = br.ReadInt16()
	f.position = br.ReadUInt16()
}

type field_storage_info struct {
	field_offset_bits uint16
	field_size_bits   uint16 // very important for reading bitpacked fields; size is the sum of all array pieces in bits - for example, uint32[3] will appear here as '96'
	// additional_data_size is the size in bytes of the corresponding section in
	// common_data or pallet_data.  These sections are in the same order as the
	// field_info, so to find the offset, add up the additional_data_size of any
	// previous fields which are stored in the same block (common_data or
	// pallet_data).
	additional_data_size uint32
	storage_type         uint32
	extra_1              uint32
	extra_2              uint32
	extra_3              uint32
}

func (f *field_storage_info) Read(br *ByteReader) {
	f.field_offset_bits = br.ReadUInt16()
	f.field_size_bits = br.ReadUInt16()
	f.additional_data_size = br.ReadUInt32()
	f.storage_type = br.ReadUInt32()
	f.extra_1 = br.ReadUInt32()
	f.extra_2 = br.ReadUInt32()
	f.extra_3 = br.ReadUInt32()
}

type copy_table_entry struct {
	id_of_new_row    uint32
	id_of_copied_row uint32
}

func (c *copy_table_entry) Read(br *ByteReader) {
	c.id_of_new_row = br.ReadUInt32()
	c.id_of_copied_row = br.ReadUInt32()
}

type offset_map_entry struct {
	offset uint32
	size   uint16
}

func (e *offset_map_entry) Read(br *ByteReader) {
	e.offset = br.ReadUInt32()
	e.size = br.ReadUInt16()
}

type relationsship_entry struct {
	foreign_id   uint32 // This is the id of the foreign key for the record, e.g. SpellID in SpellX* tables.
	record_index uint32 // This is the index of the record in record_data.  Note that this is *not* the record's own ID.
}

func (e *relationsship_entry) Read(br *ByteReader) {
	e.foreign_id = br.ReadUInt32()
	e.record_index = br.ReadUInt32()
}

type relationship_mapping struct {
	num_entries uint32
	min_id      uint32
	max_id      uint32
	entries     []relationsship_entry
}

func (e *relationship_mapping) Read(br *ByteReader) {
	e.num_entries = br.ReadUInt32()
	e.min_id = br.ReadUInt32()
	e.max_id = br.ReadUInt32()
	e.entries = make([]relationsship_entry, e.num_entries)
	for i := 0; i < int(e.num_entries); i++ {
		e.entries[i].Read(br)
	}
}

type section struct {
	records              [][]byte
	string_data          []byte
	variable_record_data []byte
	id_list              []uint32
	copy_table           []copy_table_entry
	offset_map           []offset_map_entry
	relationship_map     relationship_mapping
	offset_map_id_list   []uint32
}

func (s *section) Read(br *ByteReader, head wdc3_header, section_head wdc3_section_header) {
	if (head.flags & 1) == 0 {
		s.records = make([][]byte, section_head.record_count)
		for i := 0; i < int(section_head.record_count); i++ {
			s.records[i] = br.ReadBytes(int(head.record_size))
		}
		s.string_data = br.ReadBytes(int(section_head.string_table_size))
	} else {
		s.variable_record_data = br.ReadBytes(int(section_head.offset_records_end - section_head.file_offset))
	}

	s.id_list = make([]uint32, section_head.id_list_size/4)
	for i := 0; i < int(section_head.id_list_size/4); i++ {
		s.id_list[i] = br.ReadUInt32()
	}

	if section_head.copy_table_count > 0 {
		s.copy_table = make([]copy_table_entry, section_head.copy_table_count)
		for i := 0; i < int(section_head.copy_table_count); i++ {
			ct := copy_table_entry{}
			ct.Read(br)
			s.copy_table[i] = ct
		}
	}

	s.offset_map = make([]offset_map_entry, section_head.offset_map_id_count)
	for i := 0; i < int(section_head.offset_map_id_count); i++ {
		e := offset_map_entry{}
		e.Read(br)
		s.offset_map[i] = e
	}

	if section_head.relationship_data_size > 0 {
		// In some tables, this relationship mapping replaced columns that were used only as a lookup, such as the SpellID in SpellX* tables.
		s.relationship_map = relationship_mapping{}
		s.relationship_map.Read(br)
	}

	s.offset_map_id_list = make([]uint32, section_head.offset_map_id_count)
	for i := 0; i < int(section_head.offset_map_id_count); i++ {
		s.offset_map_id_list[i] = br.ReadUInt32()
	}
}

func openwdc3(data []byte) WDC3 {
	reader := ByteReader{data, 0}
	w := WDC3{}
	w.Header.Read(&reader)

	w.SectionHeaders = make([]wdc3_section_header, w.Header.section_count)
	for i := 0; i < int(w.Header.section_count); i++ {
		section := wdc3_section_header{}
		section.Read(&reader)
		w.SectionHeaders[i] = section
	}

	w.FieldStructures = make([]field_structure, w.Header.total_field_count)
	for i := 0; i < int(w.Header.total_field_count); i++ {
		field := field_structure{}
		field.Read(&reader)
		w.FieldStructures[i] = field
	}

	count_field_storage := w.Header.field_storage_info_size / 24
	w.FieldStorage = make([]field_storage_info, count_field_storage)
	for i := 0; i < int(count_field_storage); i++ {
		field := field_storage_info{}
		field.Read(&reader)
		w.FieldStorage[i] = field
	}

	w.PalletData = reader.ReadBytes(int(w.Header.pallet_data_size))
	w.CommonData = reader.ReadBytes(int(w.Header.common_data_size))

	w.Sections = make([]section, w.Header.section_count)
	for i := 0; i < int(w.Header.section_count); i++ {
		section := section{}

		section.Read(&reader, w.Header, w.SectionHeaders[i])
		w.Sections[i] = section
	}

	return w
}
