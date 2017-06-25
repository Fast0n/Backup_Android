#!/bin/bash

#pulizia schermo
clear && reset
echo "Per utilizzare questa versione di Backup Android devi aver installato Dialog nella tua macchina"
PS3='Quale sistema operativo usi? '
options=("Linux(apt)" "MacOS(brew)" "Dialog e' gia' installato in questa macchina")
select opt in "${options[@]}"
do
    case $opt in
        "Linux(apt)")
            echo "Installo..."
            apt install dialog
            echo "Avvio..."
            cd `pwd`/linux
            chmod +x `pwd`/run.sh && `pwd`/run.sh
            break
            ;;
        "MacOS(brew)")
            echo "Installo..."
            brew install dialog
            echo "Avvio..."
            cd `pwd`/macos
            chmod +x `pwd`/run.sh && `pwd`/run.sh
            break
            ;;
        "Dialog e' gia' installato in questa macchina")
            break
            ;;
        *) echo invalid option;;
    esac
done
