#!/bin/bash

#pulizia schermo
clear && clear && reset
#importa cartelle e file dal dispositivo a .output
./adb shell ls -1 /sdcard/ >.output
#sostituisce nei nomi 'a b' con 'a\ b'
cat .output | awk '{gsub(/ /,"\\ ")}8' > .cache
#elimina i residui di ADB, .output, e ricrea il file aggiornato
sed -i -e '1d;2d' .cache && rm .output && mv .cache .output

#tornare alla cartella precendente
a=`pwd` && a="${a/\linux/}"

#legge il file .output e usa ADB per fare il backup
while read -rs p; do
./adb pull "/mnt/sdcard/$p" $a""backup_android_linux_`date "+%d-%m-%Y"`/$p
done < .output