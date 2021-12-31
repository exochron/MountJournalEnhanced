package db2reader

import "fmt"

func ParseDB2(data []byte) wdc3_source {
	format := string(data[:4])
	if format == "WDC3" {

		w := openwdc3(data)
		o := prepareWDC3(w)

		return o
	}

	fmt.Println("unknown format: " + format)

	return wdc3_source{}
}
