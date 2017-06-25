#!/bin/bash

# Constanti
options=("Linux" "MacOS" "Esci")
PS3='Quale sistema operativo usi? '


# Funzione di backup
function backup_android {
    # importa cartelle e file dal dispositivo a .output
    ./$1/adb shell ls -1 /sdcard/ >.output

    # Sostituisce nei nomi 'a b' con 'a\ b'
    cat .output | awk '{gsub(/ /,"\\ ")}8' > .cache

    # Elimina i residui di ADB, .output, e ricrea il file aggiornato
    sed -i -e '1d;2d' .cache && rm .output && mv .cache .output

    # Crea cartella backup
    mkdir backup_android_`date "+%d-%m-%Y"`/$p 2>/dev/null

    # Legge il file .output e usa ADB per fare il backup
    while read -rs p; do
        ./$1/adb pull "/mnt/sdcard/$p" $a""backup_android_`date "+%d-%m-%Y"`/$p
    done < .output
}

## Main

# Pulizia schermo
clear && reset
echo "Backup Android"

select opt in "${options[@]}"
do
    case $opt in
        "Linux")
            clear && reset
            echo "Avvio Backup..."
            backup_android 'linux'
            break
            ;;
        "MacOS")
            clear && reset
            echo "Avvio Backup..."
            backup_android 'macos'
            break
            ;;
        "Esci")
            break
            ;;
        *) echo invalid option;;
    esac
done
