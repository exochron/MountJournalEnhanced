package main

import (
	"bytes"
	"image/color"
	"image/png"
	// 	"sync"

	"github.com/mccutchen/palettor"
	"github.com/nozzle/throttler"
)

func to_rgb(c color.Color) (red, green, blue uint8) {
	r, g, b, a := c.RGBA() // returns alpha-premultiplied values

	// convert back to non-alpha-premultiplied color (see: color.nrgbaModel())
	if a == 0 {
		r, g, b, a = 0, 0, 0, 0
	} else {
		r = ((r * 0xffff) / a) >> 8
		g = ((g * 0xffff) / a) >> 8
		b = ((b * 0xffff) / a) >> 8
		a >>= 8
	}

	// convert to rgb with white background (https://marcodiiga.github.io/rgba-to-rgb-conversion)
	alpha := float64(a) / 256.0
	red = uint8((float64(1-alpha) * 0xff) + (alpha * float64(r)))
	green = uint8((float64(1-alpha) * 0xff) + (alpha * float64(g)))
	blue = uint8((float64(1-alpha) * 0xff) + (alpha * float64(b)))

	return red, green, blue
}

func collect_colors(mount *mount, textureFileID int, casc CascGateway, t *throttler.Throttler) {
	defer t.Done(nil)

	pngFile := casc.CachedFile(int(textureFileID))
	img, _ := png.Decode(bytes.NewReader(pngFile))

	palette, _ := palettor.Extract(5, 300, img)
	for _, color := range palette.Colors() {
		mount.AddColor(to_rgb(color))
	}
}

func CollectTextures(mounts map[int]*mount, casc CascGateway, mountXDisplayDB DBFile, CreatureDisplayInfoDB DBFile) {
	displayDB := mountXDisplayDB.GetIDs()
	t := throttler.New(10, len(displayDB)*3)

	for _, xDisplayID := range displayDB {
		mountID := int(mountXDisplayDB.ReadInt(xDisplayID, 2))
		creatureDisplayID := mountXDisplayDB.ReadInt(xDisplayID, 0)
		if mount, ok := mounts[mountID]; ok {
			for i := 0; i < 3; i++ {
				textureFileID := CreatureDisplayInfoDB.ReadInt(creatureDisplayID, 24, i)
				if textureFileID > 0 {
					go collect_colors(mount, int(textureFileID), casc, t)
					t.Throttle()
				}
			}
		}
	}
}
