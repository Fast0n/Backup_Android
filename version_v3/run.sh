#!/bin/bash

# Constanti
options=("Linux" "MacOS" "Esci")
PS3='Quale sistema operativo usi? '

# Stato entry all'avvio 
opt_status='on'


# Funzione di backup
function backup_android {

    clear && reset
    echo Avvio Backup Android
    echo --------------------
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
    ./$1/adb kill-server

    # Riavvia adb
    ./$1/adb shell touch 1>/dev/null

    # Importa cartelle e file dal dispositivo a .output
    ./$1/adb shell ls -a /sdcard/ > .output

    # Rimuove . e .. dalla lista
    sed -i -e '1d;2d' .output

    # Splitta le colonne
    sed -i -e "s/\s\s/\n/g" .output

    # Fix fine righa (Android <= 6.0)
    tr -s '\r' '\n'  < .output > .cache
    mv .cache .output

    # Crea cartella backup
    mkdir backup_android_`date "+%d-%m-%Y"`/$p 2>/dev/null
}

# Menu principale
function display_menu {
    while true; do
        # Costruisco le entry del menu
        i=1
        s2=''

        while read entry; do
            entry=$(echo "$entry" | tr -s ' ' '_')
            s2+="$i $entry $opt_status "
            let i+=1
        done < .output

        # Display Menu
        OPTION=$(dialog --title "Backup Android" --checklist "Seleziona i file/cartelle da escludere dal backup (usando 'spazio')" 80 60 15 $s2 3>&1 1>&2 2>&3)

        # Scelta utente
        rv=$?

        if [ $rv == 0 ]; then
            clear

            touch .cache

            # Elimina il nome selezionato
            for entry in $OPTION; do
                sed $entry'q;d' .output >> .cache
            done

            mv .cache .output

            # Legge il file .output e usa ADB per fare il backup
            while read p; do
                ./$1/adb pull "/mnt/sdcard/$p" "backup_android_`date "+%d-%m-%Y"`/$p"
            done < .output

            rm -f .output
            exit
        else
            exit
        fi
    done
}


## Main
# Controllo sistema
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Linux
    MACHINE_TYPE=`uname -m`

    if [ ${MACHINE_TYPE} == 'x86_64' ]; then
        # 64-bit
        backup_android 'linux'
        display_menu 'linux'
    else
        # 32-bit
        backup_android 'linux32'
        display_menu 'linux32'
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    brew install dialog
    backup_android 'macos'
    display_menu 'macos'
else
    echo Sistema non riconosciuto...
fi
