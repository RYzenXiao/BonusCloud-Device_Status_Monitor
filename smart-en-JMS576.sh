#!/usr/bin/env bash

# Base on: https://github.com/BonusCloud/BonusCloud-Node
# Special thanks to qinghon https://github.com/qinghon
# Powerd by smartmontools (https://www.smartmontools.org/)

echoerr() { 
    printf "\033[1;31m$1\033[0m" 
}
echoinfo() { 
    printf "\033[1;32m$1\033[0m"
}
echowarn() { 
    printf "\033[1;33m$1\033[0m"
}

echowarn "Note: Due to the manufacturer's settings, the displayed content may be different.\n"
echowarn "      This version is only applicable to HDD enclosures with JMS576 USB bridge\n"
count=1
for sd in $(ls /dev/*|grep -E '((sd)|(vd)|(hd))[a-z]$'); do
    echoinfo "Disk $count: $sd\n"
    #smartinfo=$(smartctl -d $type -a "$sd")
    smartinfo=$(smartctl -d sat -a "$sd")
    echo "$smartinfo" | grep 'Model Family'
    echo "$smartinfo" | grep 'Device Model'
    echo "$smartinfo" | grep 'Firmware Version'
    echo "$smartinfo" | grep 'User Capacity'
    echo "$smartinfo" | grep 'Sector Sizes'
    echo "$smartinfo" | grep 'Rotation Rate'
    echo "$smartinfo" | grep 'Form Factor'
    echo "$smartinfo" | grep 'SATA Version is'

    echowarn "\nSMART overall-health self-assessment test:  "
    smart_test=$(echo "$smartinfo" | grep 'SMART overall-health self-assessment test result' | awk '{print $6}')
    if [[ ${smart_test} == "PASSED" ]]; then 
        echoinfo "${smart_test}"
    else
        echoerr "${smart_test}"
    fi
    
    echowarn "\nHard Drive SMART data: \n"
    smartctl -d sat -A "$sd" | grep -A 1000 ID#
    count=$(( $count + 1 ))
done