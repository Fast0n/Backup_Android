#!/bin/bash

# Constanti
options=("Linux" "MacOS" "Esci")
PS3='Quale sistema operativo usi? '

# Funzione di backup
function backup_android {
    # Importa cartelle e file dal dispositivo a .output
    ./$1/adb shell ls -1 -a /sdcard/ > .output

    # Elimina i residui di ADB
    sed -i -e '1d;2d' .output

    # Crea cartella backup
    mkdir backup_android_`date "+%d-%m-%Y"`/$p 2>/dev/null

function main (){
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

    # Legge il file .output e usa ADB per fare il backup
    while read p; do
        ./$1/adb pull "/mnt/sdcard/$p" "backup_android_`date "+%d-%m-%Y"`/$p"
    done < .output
    exit
fi
done
}
}
## Main
clear && reset
echo Avvio Backup Android
echo --------------------

# Controllo sistema
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Linux
    MACHINE_TYPE=`uname -m`

    if [ ${MACHINE_TYPE} == 'x86_64' ]; then
        # 64-bit
        brew install dialog
        backup_android 'linux'
        main 'linux'
        main
    else
        # 32-bit
        brew install dialog
        backup_android 'linux32'
        main 'linux32'
        main
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    brew install dialog
    backup_android 'macos'
    main 'macos'
    main
else
    echo Sistema non riconosciuto...
fi
