#!/bin/bash

cd Images || return

mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 13_options.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 14_preview.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 12_pet-assignment.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 11_options-menu.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 10_favorites-menu.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 09_notes.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 08_filter-rarity.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 07_filter-color.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 06_filter-family.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 05_filter-type.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 04_filter-source.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 03_sort.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 02_filter-profile.jpg
mv "$(ls -dtr1 ../../../../Screenshots/* | tail -1)" 01_special.jpg

magick 01_special.jpg -crop 804x735+11+121 01_special.jpg
magick 02_filter-profile.jpg -crop 843x735+11+121 02_filter-profile.jpg
magick 03_sort.jpg -crop 804x735+11+121 03_sort.jpg
magick 04_filter-source.jpg -crop 974x832+11+121 04_filter-source.jpg
magick 05_filter-type.jpg -crop 804x735+11+121 05_filter-type.jpg
magick 06_filter-family.jpg -crop 910x1029+11+121 06_filter-family.jpg
magick 07_filter-color.jpg -crop 804x735+11+121 07_filter-color.jpg
magick 08_filter-rarity.jpg -crop 804x735+11+121 08_filter-rarity.jpg
magick 09_notes.jpg -crop 804x735+11+121 09_notes.jpg
magick 10_favorites-menu.jpg -crop 804x735+11+121 10_favorites-menu.jpg
magick 11_options-menu.jpg -crop 435x444+745+128 11_options-menu.jpg
magick 12_pet-assignment.jpg -crop 762x735+360+121 12_pet-assignment.jpg
magick 13_options.jpg -crop 799x820+1770+130 13_options.jpg
magick 14_preview.jpg -crop 519x634+11+121 14_preview.jpg