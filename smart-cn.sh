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

echowarn "注意: 由于不同厂商设定原因，SMART信息可能会不同\n"
count=1
for sd in $(ls /dev/*|grep -E '((sd)|(vd)|(hd))[a-z]$'); do
    for type_tmp in sat scsi nvme ata usbcypress usbjmicron usbprolific usbsunplus marvell areca 3ware hpt megaraid aacraid cciss; do
        ret=$(smartctl -d $type_tmp --all $sd >/dev/null;echo $?)
        if [[ $ret -eq 4 || $ret -eq 0 ]]; then
            type=$type_tmp
            break
        fi
    done
    
    echoinfo "第$count块硬盘: $sd\n"
    smartinfo=$(smartctl -d $type -a "$sd")
    echo "$smartinfo" | grep 'Model Family'
    echo "$smartinfo" | grep 'Device Model'
    echo "$smartinfo" | grep 'Firmware Version'
    echo "$smartinfo" | grep 'User Capacity'
    echo "$smartinfo" | grep 'Sector Sizes'
    echo "$smartinfo" | grep 'Rotation Rate'
    echo "$smartinfo" | grep 'Form Factor'
    echo "$smartinfo" | grep 'SATA Version is'

    echowarn "\nSMART健康度自检测试:  "
    smart_test=$(echo "$smartinfo" | grep 'SMART overall-health self-assessment test result' | awk '{print $6}')
    if [[ ${smart_test} == "PASSED" ]]; then 
        echoinfo "通过 / ${smart_test}"
    else
        echoerr "${smart_test}"
    fi
    
    echowarn "\n硬盘SMART数据: \n"
    smartctl -d sat -A "$sd" | grep -A 1000 ID#
    count=$(( $count + 1 ))
done