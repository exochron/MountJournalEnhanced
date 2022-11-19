package main

import (
	"io/ioutil"
	"log"

	"gopkg.in/yaml.v3"
)

type familyConfig struct {
	Name      string
	Wcm       []string
	Icons     []string
	Ids       []int
	SubFamily []familyConfig
	Mounts    []mount
}

type config struct {
	Product   string
	CacheDir  string
	Ignored   []int
	FamilyMap []familyConfig
}

func LoadConfig() config {
	var c config
	yfile, _ := ioutil.ReadFile("config.yml")
	if err := yaml.Unmarshal(yfile, &c); err != nil {
		log.Fatal(err)
	}
	return c
}
