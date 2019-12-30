#!/usr/bin/env bash
#
#  Copyright (c) 2019 European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# Author  : Jeong Han Lee
# email   : jeonghan.lee@gmail.com
# Date    : Monday, December 30 11:58:55 CET 2019
#
# version : 0.0.2

declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_SCRIPTNAME=${0##*/}
declare -gr SC_TOP="${SC_SCRIPT%/*}"
declare -gr SC_LOGDATE="$(date +%y%m%d%H%M)"

# declare -gr SUDO_CMD=$(which sudo);
  
printf "\n>>> Current System Clock Source : it should be tsc.\n";
cat /sys/devices/system/clocksource/clocksource0/current_clocksource

printf "\n>>> Boot Cmdline \n";
cat /proc/cmdline

printf "\n>>> pidstat -C isolcpus\n"
pidstat -C isolcpus
printf "\n>>> Present CPU core \n"
cat /sys/devices/system/cpu/present
printf "\n>>> Isolated CPU core \n"
cat /sys/devices/system/cpu/isolated

printf "\n>>> System service : irqbalance\n"
systemctl status irqbalance


printf "\n>>> System service : tuned\n"
systemctl status tuned

printf "\n    Tune Active Profile \n";
tuned-adm active

printf "\n    Tune Realtime variable \n";
cat /etc/tuned/realtime-variables.conf

printf "\n    Tune Realtime bootcmdline\n";
tail -n 2 /etc/tuned/bootcmdline

printf "\n>>> pidstat\n";
pidstat |grep "   0  [a-z,A-Z,0-9]"
pidstat |grep "   1  [a-z,A-Z,0-9]"
pidstat |grep "   2  [a-z,A-Z,0-9]"
pidstat |grep "   3  [a-z,A-Z,0-9]"
pidstat |grep "   4  [a-z,A-Z,0-9]"
pidstat |grep "   5  [a-z,A-Z,0-9]"
pidstat |grep "   6  [a-z,A-Z,0-9]"
pidstat |grep "   7  [a-z,A-Z,0-9]"
pidstat |grep "   8  [a-z,A-Z,0-9]"
pidstat |grep "   9  [a-z,A-Z,0-9]"
