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
}

# Menu principale
function display_menu {
    while true; do
        # Costruisco le entry del menu
        i=1
        s2=''

        for entry in `cat .output`; do
            s2+="$i $entry "
            let i+=1
        done

        # Display Menu
        OPTION=$(dialog --title "Backup Android" --extra-button --extra-label "Backup"\
                 --menu "Seleziona i file/cartelle da escludere dal backup" 80 60 15 $s2 3>&1 1>&2 2>&3)

        # Scelta utente
        rv=$?

        if [ $rv == 3 ]; then
            clear

            # Legge il file .output e usa ADB per fare il backup
            while read p; do
                ./$1/adb pull "/mnt/sdcard/$p" "backup_android_`date "+%d-%m-%Y"`/$p"
            done < .output

            rm -f .output
            exit
        elif [ $rv == 0 ]; then
            # Elimina il nome selezionato
            sed -i -e $OPTION'd' .output
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
