package main

import (
	"io/ioutil"
	"log"
	"net/http"
)

func httpGet(url string) []byte {
	resp, err := http.Get(url)
	if err != nil {
		print(err)
	}
	defer resp.Body.Close()

	payload, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		log.Fatal(err)
	}

	return payload
}
