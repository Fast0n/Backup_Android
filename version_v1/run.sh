#!/bin/bash

# Constanti
options=("Linux" "MacOS" "Esci")
PS3='Quale sistema operativo usi? '


# Funzione di backup
function backup_android {

    echo "          ______           _     ___                      "
    echo "         |  ____|         | |   / _ \                     "
    echo "         | |__  __ _  ___ | |_ | | | | _ __               "
    echo "         |  __|/ _  |/ __|| __|| | | || '_ \              "
    echo "         | |  | (_| |\__ \| |_ | |_| || | | |             "
    echo "         |_|   \__,_||___/ \__| \___/ |_| |_|             "
    echo "                                                          "
    echo "                __  _                                     "
    echo "               / _|| |                                    "
    echo "   ___   ___  | |_ | |_ __      __ __ _  _ __  ___        "
    echo "  / __| / _ \ |  _|| __|\ \ /\ / // _  ||  __|/ _ "'\'"   "
    echo "  "'\'"__ \| |_| || |  | |_  \ V  V /| (_| || |  |  __/   "
    echo "  |___/ \___/ |_|   \__|  \_/\_/  \____||_|   \___|       "
    echo "                                                          "
    sleep 2
    clear

    # Kill-server (Android <= 6.0)
    ./$1/adb kill-server 1>/dev/null

    # Riavvia adb
    ./$1/adb start-server 1>/dev/null

    # Clean
    rm -f .output 2>/dev/null

    # Importa cartelle e file dal dispositivo a .output
    ./$1/adb shell find /sdcard/ -maxdepth 1 > .output

    # Rimuove prefisso cartella
    sed -i -e "s/\/sdcard\///g" .output
    sed -i -e '1d' .output

    # Ordina l'output
    sort .output > .cache
    mv .cache .output

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
