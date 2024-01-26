#!/bin/bash

cd Images || return

mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 11_options.jpg
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

convert -crop 804x735+11+121 01_special.jpg 01_special.jpg
convert -crop 804x735+11+121 02_sort.jpg 02_sort.jpg
convert -crop 804x735+11+121 03_filter-source.jpg 03_filter-source.jpg
convert -crop 804x735+11+121 04_filter-type.jpg 04_filter-type.jpg
convert -crop 804x964+11+121 05_filter-family.jpg 05_filter-family.jpg
convert -crop 804x735+11+121 06_filter-color.jpg 06_filter-color.jpg
convert -crop 804x735+11+121 07_filter-rarity.jpg 07_filter-rarity.jpg
convert -crop 804x735+11+121 08_notes.jpg 08_notes.jpg
convert -crop 804x735+11+121 09_favorites-menu.jpg 09_favorites-menu.jpg
convert -crop 364x373+745+128 10_options-menu.jpg 10_options-menu.jpg
convert -crop 799x820+1644+130 11_options.jpg 11_options.jpg