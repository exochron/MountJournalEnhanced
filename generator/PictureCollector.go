package main

import (
	"bytes"
	"image/color"
	"image/png"

	"github.com/mccutchen/palettor"
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

func CollectTextures(mounts map[int]mount, casc CascGateway, mountXDisplayDB DBFile, CreatureDisplayInfoDB DBFile) map[int]mount {
	// km, _ := kmeans.NewWithOptions(0.001, nil)

	for _, xDisplayID := range mountXDisplayDB.GetIDs() {
		mountID := int(mountXDisplayDB.ReadInt(xDisplayID, 2))
		creatureDisplayID := mountXDisplayDB.ReadInt(xDisplayID, 0)
		if mount, ok := mounts[mountID]; ok {
			textureFileID := CreatureDisplayInfoDB.ReadInt(creatureDisplayID, 24)
			if textureFileID > 0 {
				// var pixels clusters.Observations
				pngFile := casc.CachedFile(int(textureFileID))
				img, _ := png.Decode(bytes.NewReader(pngFile))

				palette, _ := palettor.Extract(3, 100, img)
				for _, color := range palette.Colors() {
					mount.AddColor(to_rgb(color))
				}
				/*
					fmt.Printf("%v: %vx%v\n", textureFileID, img.Bounds().Dx(), img.Bounds().Dy())
					for y := 0; y < img.Bounds().Dy(); y++ {
						for x := 0; x < img.Bounds().Dx(); x++ {
							c := img.At(x, y)
							r, g, b, a := c.RGBA()
							if r != 0 || g != 0 || b != 0 || a != 0xffff { // filter white
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
								red := (float64(1-alpha) * 0xff) + (alpha * float64(r))
								green := (float64(1-alpha) * 0xff) + (alpha * float64(g))
								blue := (float64(1-alpha) * 0xff) + (alpha * float64(b))

								// add to collection
								pixels = append(pixels, clusters.Coordinates{red, green, blue})
							}
						}
					}

					mean_clusters, _ := km.Partition(pixels, 3)
					for _, cluster := range mean_clusters {
						fmt.Printf("direct3#file %v = rgba: %v %v %v   %v/%v\n", textureFileID, uint32(cluster.Center[0]), uint32(cluster.Center[1]), uint32(cluster.Center[2]), len(cluster.Observations), len(pixels))
					}

					subclusters, _ := km.Partition(pixels, 20)
					var pixelcats clusters.Observations
					for _, cluster := range subclusters {
						pixelcats = append(pixelcats, clusters.Coordinates{cluster.Center[0], cluster.Center[1], cluster.Center[2]})
					}
					finalclusters, _ := km.Partition(pixelcats, 3)
					for _, cluster := range finalclusters {
						fmt.Printf("remean10#file %v = rgba: %v %v %v   %v/%v\n", textureFileID, uint32(cluster.Center[0]), uint32(cluster.Center[1]), uint32(cluster.Center[2]), len(cluster.Observations), len(pixels))
					}*/

				mounts[mountID] = mount
			}
		}
	}

	return mounts
}
