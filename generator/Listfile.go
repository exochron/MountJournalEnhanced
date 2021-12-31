package main

import (
	"bytes"
	"encoding/csv"
	"log"
	"strconv"
)

func LoadListfile() map[int]string {
	data := httpGet("https://github.com/wowdev/wow-listfile/blob/master/community-listfile.csv?raw=true")
	csvReader := csv.NewReader(bytes.NewReader(data))
	csvReader.Comma = ';'
	records, err := csvReader.ReadAll()

	if err != nil {
		log.Fatal(err)
	}

	result := map[int]string{}
	for _, record := range records {
		fileId, _ := strconv.Atoi(record[0])
		result[fileId] = record[1]
	}

	return result
}
