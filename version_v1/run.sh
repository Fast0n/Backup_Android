#!/bin/bash

# Constanti
options=("Linux" "MacOS" "Esci")
PS3='Quale sistema operativo usi? '


# Funzione di backup
function backup_android {
    # importa cartelle e file dal dispositivo a .output
    ./$1/adb shell ls -1 -a /sdcard/ > .output

    # Elimina i residui di ADB
    sed -i '1d;2d' .output

    # Crea cartella backup
    mkdir backup_android_`date "+%d-%m-%Y"`/$p 2>/dev/null

    # Legge il file .output e usa ADB per fare il backup
    while read p; do
        ./$1/adb pull "/mnt/sdcard/$p" "backup_android_`date "+%d-%m-%Y"`/$p"
    done < .output
}

## Main
clear && reset
echo Avvio Backup Android...

# Controllo sistema
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Linux
    backup_android 'linux'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    backup_android 'macos'
fi
