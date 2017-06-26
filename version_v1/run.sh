#!/bin/bash

# Constanti
options=("Linux" "MacOS" "Esci")
PS3='Quale sistema operativo usi? '


# Funzione di backup
function backup_android {
    # Importa cartelle e file dal dispositivo a .output
    ./$1/adb shell ls -1 -A /sdcard/ > .output

    # Crea cartella backup
    mkdir backup_android_`date "+%d-%m-%Y"`/$p 2>/dev/null

    # Legge il file .output e usa ADB per fare il backup
    while read p; do
        ./$1/adb pull "/mnt/sdcard/$p" "backup_android_`date "+%d-%m-%Y"`/$p"
    done < .output

    rm -f .output
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
        backup_android 'linux'
    else
        # 32-bit
        backup_android 'linux32'
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    backup_android 'macos'
else
    echo Sistema non riconosciuto...
fi
