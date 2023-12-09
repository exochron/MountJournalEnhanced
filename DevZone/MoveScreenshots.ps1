# move most recent screenshot into ./Images with specific name
$files = ("01_special.jpg", '02_sort.jpg', '03_filter-source.jpg', '04_filter-type.jpg', '05_filter-family.jpg', '06_filter-color.jpg', '07_filter-rarity.jpg', '08_notes.jpg', '09_favorites-menu.jpg', '10_options-menu.jpg', '11_options.jpg')
gci ..\..\..\Screenshots\ | sort LastWriteTime |select -last $files.Count | ForEach-Object -Begin{ $i=0 } -Process { $f=$files[$i++]; move ..\..\..\Screenshots\$_ .\Images\$f -Force }

# using imagick convert to crop images
# https://imagemagick.org/script/command-line-options.php#crop
function convert
{
    docker run --rm -d -v .\Images\:/imgs dpokidov/imagemagick:latest @args
}
convert -crop 880x800+10+130 01_special.jpg 01_special.jpg
convert -crop 880x800+10+130 02_sort.jpg 02_sort.jpg
convert -crop 880x800+10+130 03_filter-source.jpg 03_filter-source.jpg
convert -crop 880x800+10+130 04_filter-type.jpg 04_filter-type.jpg
convert -crop 880x1050+10+130 05_filter-family.jpg 05_filter-family.jpg
convert -crop 880x800+10+130 06_filter-color.jpg 06_filter-color.jpg
convert -crop 880x800+10+130 07_filter-rarity.jpg 07_filter-rarity.jpg
convert -crop 880x800+10+130 08_notes.jpg 08_notes.jpg
convert -crop 880x800+10+130 09_favorites-menu.jpg 09_favorites-menu.jpg
convert -crop 415x415+800+130 10_options-menu.jpg 10_options-menu.jpg
convert -crop 870x895+1745+140 11_options.jpg 11_options.jpg
