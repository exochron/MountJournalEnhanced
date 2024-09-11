#!/bin/bash

cd Images || return

mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 11_options.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 12_preview.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 10_options-menu.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 09_favorites-menu.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 08_notes.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 07_filter-rarity.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 06_filter-color.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 05_filter-family.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 04_filter-type.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 03_filter-source.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 02_sort.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 01_special.jpg

magick 01_special.jpg -crop 804x735+11+121 01_special.jpg
magick 02_sort.jpg -crop 804x735+11+121 02_sort.jpg
magick 03_filter-source.jpg -crop 804x802+11+121 03_filter-source.jpg
magick 04_filter-type.jpg -crop 804x735+11+121 04_filter-type.jpg
magick 05_filter-family.jpg -crop 804x1029+11+121 05_filter-family.jpg
magick 06_filter-color.jpg -crop 804x735+11+121 06_filter-color.jpg
magick 07_filter-rarity.jpg -crop 804x735+11+121 07_filter-rarity.jpg
magick 08_notes.jpg -crop 804x735+11+121 08_notes.jpg
magick 09_favorites-menu.jpg -crop 804x735+11+121 09_favorites-menu.jpg
magick 10_options-menu.jpg -crop 435x422+745+128 10_options-menu.jpg
magick 11_options.jpg -crop 799x820+1770+130 11_options.jpg
magick 12_preview.jpg -crop 519x634+11+121 12_preview.jpg