#!/bin/bash

#pulizia schermo
clear && reset
echo "Backup Android"
PS3='Quale sistema operativo usi? '
options=("Linux(apt)" "MacOS(brew)" "Esci")
select opt in "${options[@]}"
do
    case $opt in
        "Linux(apt)")
            echo "Avvio..."
            cd `pwd`/linux
            chmod +x `pwd`/run.sh && `pwd`/run.sh
            break
            break
            ;;
        "MacOS(brew)")
            echo "Avvio..."
            cd `pwd`/macos
            chmod +x `pwd`/run.sh && `pwd`/run.sh
            break
            ;;
        "Esci")
            break
            ;;
        *) echo invalid option;;
    esac
done