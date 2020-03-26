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
echorun() {
    case $1 in
        "1" ) echoerr "未运行\t" ;;
        "0" ) echoinfo "运行中\t";;
    esac
}

echowarn "已调度进程和使用情况:  "
lvm_have=$(lvs 2>/dev/null|grep -q 'BonusVolGroup';echo $?)
[[ ${lvm_have} -eq 0  ]] && { echorun "0";}|| echorun "1"

echowarn "\n已同步数据:  "
syncd="$(df -h|grep "bonusvol"|awk '{sum += int($3)}; END {print sum}')"
echoinfo "${syncd} GB "
echo -e "($(lvs|grep BonusVolGroup|grep bonusvol|awk '{sum += int($4)}; END {print ('${syncd}'/sum)*100}')%)"

echowarn "硬盘已分配空间:  "
lvm_used="$(lvs|grep BonusVolGroup|grep bonusvol|awk '{sum += int($4)}; END {print sum}')"
echoinfo "${lvm_used} GB   "

echowarn "硬盘未分配空间:  "
free_space=$(vgs|grep 'BonusVolGroup'|awk '{print $7}'|sed 's/\g//g')
if [[ "$free_space" < 25.25 ]]; then
    echoerr "$free_space"
else 
    if [[ "$free_space" < 105.105 ]]; then
        echowarn "$free_space GB"
    else
        echoinfo "$free_space GB"
    fi
fi

#任务显示
declare -A dict

# 任务类型字典
dict=([iqiyi]="A" [baijing]="B" [65542v]="C" [65541v]="D" [65540v]="E")

[[ ${lvm_have} -eq 0  ]] &&lvs_info=$(lvs 2>/dev/null|grep BonusVolGroup|grep bonusvol)
[[ ${lvm_have} -eq 0  ]] &&lvlist=$(echo "$lvs_info"|awk '{print $1}'|sed -r 's#bonusvol([A-Za-z0-9]+)[0-9]{2}#\1#g'|sort -ru)
[[ ${lvm_have} -eq 0  ]] &&echowarn "\n 类型\t\t 已使用\t 未使用\t 占用百分比\n"
for lv in $lvlist; do
    TYPE=${dict[$lv]}
    lvm_num=$(echo "$lvs_info"|awk '{print $1}'|grep -c "$lv")
    lvm_size=$(echo "$lvs_info"|grep "$lv"|awk '{print $4}'|head -n 1|sed 's/\.00g//g')
    echoinfo " ${TYPE}-${lvm_num}-${lvm_size}GB\n" 
    echo -e "$(df -h|grep "bonusvol$lv"|awk '{print "  |──\t\t", $3, "\t", $4, "\t\033[1;32m", $5,"\033[0m", "\t"}')"
done
