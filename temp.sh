#!/usr/bin/env bash

# Base on: https://github.com/BonusCloud/BonusCloud-Node
# Special thanks to qinghon https://github.com/qinghon

echoerr() { 
    printf "\033[1;31m$1\033[0m" 
}
echoinfo() { 
    printf "\033[1;32m$1\033[0m"
}
echowarn() { 
    printf "\033[1;33m$1\033[0m"
}

for sd in $(ls /dev/*|grep -E '((sd)|(vd)|(hd))[a-z]$'); do
    for type_tmp in sat scsi nvme ata usbcypress usbjmicron usbprolific usbsunplus marvell areca 3ware hpt megaraid aacraid cciss; do
        # echo $type_tmp
        ret=$(smartctl -d $type_tmp --all $sd >/dev/null;echo $?)
        # echo $ret
        # ret=$(($ret & 8))
        if [[ $ret -eq 4 || $ret -eq 0 ]]; then
            type=$type_tmp
            break
        fi
    done
    echowarn "Hard Drive information: "
    echoinfo "\t$sd \tDevice Type: $type\n"
    smartinfo=$(smartctl -d $type -a "$sd")
    echo "$smartinfo" | grep 'Model Family'
    echo "$smartinfo" | grep 'Device Model'
    echo "$smartinfo" | grep 'Firmware Version'
    echo "$smartinfo" | grep 'User Capacity'
    echo "$smartinfo" | grep 'Sector Sizes'
    echo "$smartinfo" | grep 'Rotation Rate'
    echo "$smartinfo" | grep 'Form Factor'
    echo "$smartinfo" | grep 'SATA Version is'

    echowarn "\nHard Drive SMART data: \n"
    printf "ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE\n"
    echo "$smartinfo" | grep 'Spin_Up_Time'
    echo "$smartinfo" | grep 'Start_Stop_Count'
    echo "$smartinfo" | grep 'Reallocated_Sector_Ct'
    echo "$smartinfo" | grep 'Seek_Error_Rate'
    echo "$smartinfo" | grep 'Power_On_Hours'
    echo "$smartinfo" | grep 'Spin_Retry_Count'
    echo "$smartinfo" | grep 'Power_Cycle_Count'
    echo "$smartinfo" | grep 192
    echo "$smartinfo" | grep 193
    echo "$smartinfo" | grep 196
    echo "$smartinfo" | grep 197
    echo "$smartinfo" | grep 198
    echo "$smartinfo" | grep 199

    echowarn "\nSMART overall-health self-assessment test:  "
    smart_test=$(echo "$smartinfo" | grep 'SMART overall-health self-assessment test result' | awk '{print $6}')
    if [[ ${smart_test} == "PASSED" ]]; then 
        echoinfo "PASSED"
    fi
    # 硬盘温度展示，同样依赖smartmontools   
    T1=$(echo "$smartinfo" | grep 194 | awk '{print $10}')
    T2=$(echo "$smartinfo"| grep 194 | awk '{print $11, $12}')
    echowarn "\n\nHard Drive Temperature: "
    if [[ ${T1} < 50 ]]; then 
        echoinfo "${T1}°C"
    else if [[ ${T1} < 75 ]]; then 
        echowarn "${T1}°C"
    else
        echoerr "${T1}°C"
    fi
    fi
    echo " ${T2}"
done