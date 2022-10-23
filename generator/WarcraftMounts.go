package main

import (
	"html"
	"regexp"
	"strings"
)

func LoadMountFamilies() map[string]string {
	htmlBody := httpGet("https://www.warcraftmounts.com/gallery.php")

	categoryReg := regexp.MustCompile(`(?Usi)<h5><a id='(.*)'>.*</div>\s+</span>`)
	itemReg := regexp.MustCompile(`(?Usi)<img class='thumbimage' src='.*' alt='(.*)' />`)

	families := map[string]string{}

	for _, category := range categoryReg.FindAllSubmatch(htmlBody, -1) {
		familyName := string(category[1])

		for _, item := range itemReg.FindAllSubmatch(category[0], -1) {
			mountName := string(item[1])
			mountName = html.UnescapeString(mountName)
			mountName = strings.ToLower(mountName)
			mountName = strings.Replace(mountName, " [horde]", "", -1)
			mountName = strings.Replace(mountName, " [alliance]", "", -1)
			mountName = strings.Replace(mountName, " [Horde]", "", -1)
			mountName = strings.Replace(mountName, " [Alliance]", "", -1)
			families[mountName] = familyName
		}
	}

	return families
}
