package db2reader

import (
	"encoding/binary"
)

type ByteReader struct {
	data    []byte
	pointer uint
}

func (r *ByteReader) ReadInt16() int16 {
	start := r.pointer
	r.pointer += 2
	var value int16
	value |= int16(r.data[start])
	value |= (int16(r.data[start+1]) << 8)
	return value
}

func (r *ByteReader) ReadUInt16() uint16 {
	start := r.pointer
	r.pointer += 2
	end := r.pointer
	return binary.LittleEndian.Uint16(r.data[start:end])
}
func (r *ByteReader) ReadUInt32() uint32 {
	start := r.pointer
	r.pointer += 4
	end := r.pointer
	return binary.LittleEndian.Uint32(r.data[start:end])
}
func (r *ByteReader) ReadUInt64() uint64 {
	start := r.pointer
	r.pointer += 8
	end := r.pointer
	return binary.LittleEndian.Uint64(r.data[start:end])
}

func (r *ByteReader) ReadString(length int) string {
	start := r.pointer
	r.pointer += uint(length)
	end := r.pointer
	return string(r.data[start:end])
}

func (r *ByteReader) ReadBytes(length int) []byte {
	start := r.pointer
	r.pointer += uint(length)
	end := r.pointer
	return r.data[start:end]
}
