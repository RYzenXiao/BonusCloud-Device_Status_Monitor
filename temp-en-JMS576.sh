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

echowarn "Note: This version is only applicable to HDD enclosures with JMS576 USB bridge\n"
echowarn "CPU Temperature:  "
T3=$(cat /sys/class/thermal/thermal_zone0/temp | awk '{print int($1/1000)}')
if [[ ${T3} < 60 ]]; then  
    echoinfo "${T3}°C\n"
else
    echoerr "${T3}°C\n"
fi

echowarn "Hard Drive Temperature: \n"
count=1
for sd in $(ls /dev/*|grep -E '((sd)|(vd)|(hd))[a-z]$'); do
    smartinfo=$(smartctl -d sat -a "$sd")
    T1=$(echo "$smartinfo" | grep 194 | awk '{print $10}')
    T2=$(echo "$smartinfo"| grep 194 | awk '{print $11, $12}')
    printf "Disk $count ("
    echoinfo "$sd"
    printf "):  "
    if [[ ${T1} < 50 ]]; then 
        echoinfo "${T1}°C"
    else if [[ ${T1} < 75 ]]; then 
        echowarn "${T1}°C"
    else
        echoerr "${T1}°C"
    fi
    fi
    echo " ${T2}"
    count=$(( $count + 1 ))
done