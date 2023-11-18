gci ..\..\..\Screenshots\ | sort LastWriteTime |select -last 1 | ForEach-Object { move ..\..\..\Screenshots\$_ .\Images\11_options.jpg -Force}
gci ..\..\..\Screenshots\ | sort LastWriteTime |select -last 1 | ForEach-Object { move ..\..\..\Screenshots\$_ .\Images\10_options-menu.jpg -Force}
gci ..\..\..\Screenshots\ | sort LastWriteTime |select -last 1 | ForEach-Object { move ..\..\..\Screenshots\$_ .\Images\09_favorites-menu.jpg -Force}
gci ..\..\..\Screenshots\ | sort LastWriteTime |select -last 1 | ForEach-Object { move ..\..\..\Screenshots\$_ .\Images\08_notes.jpg -Force}
gci ..\..\..\Screenshots\ | sort LastWriteTime |select -last 1 | ForEach-Object { move ..\..\..\Screenshots\$_ .\Images\07_filter-rarity.jpg -Force}
gci ..\..\..\Screenshots\ | sort LastWriteTime |select -last 1 | ForEach-Object { move ..\..\..\Screenshots\$_ .\Images\06_filter-color.jpg -Force}
gci ..\..\..\Screenshots\ | sort LastWriteTime |select -last 1 | ForEach-Object { move ..\..\..\Screenshots\$_ .\Images\05_filter-family.jpg -Force}
gci ..\..\..\Screenshots\ | sort LastWriteTime |select -last 1 | ForEach-Object { move ..\..\..\Screenshots\$_ .\Images\04_filter-type.jpg -Force}
gci ..\..\..\Screenshots\ | sort LastWriteTime |select -last 1 | ForEach-Object { move ..\..\..\Screenshots\$_ .\Images\03_filter-source.jpg -Force}
gci ..\..\..\Screenshots\ | sort LastWriteTime |select -last 1 | ForEach-Object { move ..\..\..\Screenshots\$_ .\Images\02_sort.jpg -Force}
gci ..\..\..\Screenshots\ | sort LastWriteTime |select -last 1 | ForEach-Object { move ..\..\..\Screenshots\$_ .\Images\01_special.jpg -Force}


docker run --rm -v .\Images\:/imgs dpokidov/imagemagick:latest -crop 880x800+10+130 01_special.jpg 01_special.jpg
docker run --rm -v .\Images\:/imgs dpokidov/imagemagick:latest -crop 880x800+10+130 02_sort.jpg 02_sort.jpg
docker run --rm -v .\Images\:/imgs dpokidov/imagemagick:latest -crop 880x800+10+130 03_filter-source.jpg 03_filter-source.jpg
docker run --rm -v .\Images\:/imgs dpokidov/imagemagick:latest -crop 880x800+10+130 04_filter-type.jpg 04_filter-type.jpg
docker run --rm -v .\Images\:/imgs dpokidov/imagemagick:latest -crop 880x1050+10+130 05_filter-family.jpg 05_filter-family.jpg
docker run --rm -v .\Images\:/imgs dpokidov/imagemagick:latest -crop 880x800+10+130 06_filter-color.jpg 06_filter-color.jpg
docker run --rm -v .\Images\:/imgs dpokidov/imagemagick:latest -crop 880x800+10+130 07_filter-rarity.jpg 07_filter-rarity.jpg
docker run --rm -v .\Images\:/imgs dpokidov/imagemagick:latest -crop 880x800+10+130 08_notes.jpg 08_notes.jpg
docker run --rm -v .\Images\:/imgs dpokidov/imagemagick:latest -crop 880x800+10+130 09_favorites-menu.jpg 09_favorites-menu.jpg
docker run --rm -v .\Images\:/imgs dpokidov/imagemagick:latest -crop 390x395+800+130 10_options-menu.jpg 10_options-menu.jpg
docker run --rm -v .\Images\:/imgs dpokidov/imagemagick:latest -crop 870x895+1745+140 11_options.jpg 11_options.jpg
