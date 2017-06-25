#!/bin/bash

#pulizia schermo
clear && clear && reset
#importa cartelle e file dal dispositivo a .output
./adb shell ls -1 /sdcard/ >.output
#sostituisce nei nomi 'a b' con 'a\ b'
cat .output | awk '{gsub(/ /,"\\ ")}8' > .cache
#elimina i residui di ADB, .output, e ricrea il file aggiornato
sed -i -e '1d;2d' .cache && rm .output && mv .cache .output

main(){
s2=()
#numero di line dentro il file .output
cnt=$(wc -l < .output)
j=0
for ((i=1;i<cnt+1;i++)); do
	s2[j]=`expr $i + 0`
	j=`expr $j + 1`
	s2[j]=$(sed -n $i'p' < .output)
	j=`expr $j + 1` 
done
while true 
do
OPTION=$(dialog --title "Backup Android" --menu "Seleziona i file/cartelle da escludere dal backup \n\n(Per confermare il backup clicca su Cancel)"  80 60 15 "${s2[@]}" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
	#elimina i nomi selezionati
	sed -i -e $OPTION'd'  .output
	main
else
	#tornare alla cartella precendente
	a=`pwd` && a="${a/\macos/}"

	#legge il file .output e usa ADB per fare il backup
	while read -rs p; do
	./adb pull "/mnt/sdcard/$p" $a""backup_android_macos_`date "+%d-%m-%Y"`/$p
	done < .output
	exit
fi
done
}
main