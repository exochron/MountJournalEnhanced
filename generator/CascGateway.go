package main

import (
	"errors"
	"fmt"
	"io/fs"
	"os"
	"strconv"
)

type CascGateway struct {
	Product   string
	Locale    string
	CachePath string
}

func (cg CascGateway) request(path string) []byte {
	const url = "https://casc.everynothing.net/"
	path = path + "?product=" + cg.Product + "&locale=" + cg.Locale
	fmt.Println("downloading " + path)
	return httpGet(url + path)
}

func (cg CascGateway) LoadDB2(filename string) []byte {
	return cg.request("dbfilesclient/" + filename + ".db2")
}

func (cg CascGateway) CachedFile(fileID int) []byte {
	fId := strconv.Itoa(fileID)
	localFile := cg.CachePath + fId

	payload, err := os.ReadFile(localFile)
	if errors.Is(err, os.ErrNotExist) {
		payload := cg.request(fId)
		os.WriteFile(localFile, payload, fs.FileMode(os.O_CREATE|os.O_TRUNC|os.O_WRONLY))
		return payload
	}

	return payload
}
