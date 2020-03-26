# BonusCloud-Device_Status
代码节选自：https://github.com/BonusCloud/BonusCloud-Node

Code excerpt from https://github.com/BonusCloud/BonusCloud-Node

----------------------------------------------------------------------------------------------------------------------

硬盘smart检测部分来自smartmontools (https://www.smartmontools.org/) ，需要在系统中先安装smartctl

Hard drive smart detection part comes from smartmontools (https://www.smartmontools.org/), smartctl need to be installed first.

----------------------------------------------------------------------------------------------------------------------

作为方便个人查看LVM使用情况及硬盘smart

As a convenient personal check of LVM usage and hard drive smart

----------------------------------------------------------------------------------------------------------------------

目前未知以后会怎么样，主要是做着好玩而已

It's unknown what will happen in the future, mainly for fun.

----------------------------------------------------------------------------------------------------------------------

progress用于显示任务调度情况以及磁盘使用情况

progress-en.sh is used to display task scheduling and disk usage

----------------------------------------------------------------------------------------------------------------------

temp用于显示CPU温度和磁盘温度

temp-en.sh is used to display CPU temperature and disk temperature

----------------------------------------------------------------------------------------------------------------------

smart用于显示磁盘smart状态

smart-en.sh is used to display the disk smart status.

----------------------------------------------------------------------------------------------------------------------

文件名结尾带cn表示是显示中文，带H1的表示为JMS576主控硬盘盒(常见于H1硬盘盒)做的版本

File name with "en" means it will display in English and file name with "JMS576" is for hard drive adapter with JMS576 USB bridge.
