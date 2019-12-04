#!/usr/bin/env bash
#
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
#
# - increase a IRQ thread priority of a input CMD name
#
#  author : Jeong Han Lee
#  email  : jeonghan.lee@gmail.com
#  date   : 
#  version : 0.0.1


# root@:~# chrt -m
# SCHED_OTHER min/max priority    : 0/0
# SCHED_FIFO min/max priority     : 1/99
# SCHED_RR min/max priority       : 1/99
# SCHED_BATCH min/max priority    : 0/0
# SCHED_IDLE min/max priority     : 0/0


function check_PREEMPT_RT
{

    local kernel_uname=$(uname -r)
    local rt_patch="preempt-rt";
    local kernel_status=0;
    local realtime_status=$(cat /sys/kernel/realtime)
    
    if test "${kernel_uname#*$rt_patch}" != "${kernel_uname}"; then
	kernel_status=1;
    else
	kernel_status=0;
    fi
    
    if [[ $kernel_status && $realtime_status ]]; then
	printf "This is the realtime patch system, and go further...\n";
    else
	printf "This is not the realtime patch system, and stop here\n";
	exit;
    fi
}

function return_ps 
{
   local cmd="$1"; shift;
   local result="";
   result=$(ps -eTo tid,rtprio,cls,pri,cmd c | grep ${cmd});
   echo ${result};
}

printf "\n"
printf "Check whether the kernel supports realtime features\n";

declare CMD="$1";
declare NEWIRQPRIO="$2";

if [ -z "${CMD}" ]; then
	echo "">&2
        echo "usage: $0 <command_name> <new_irq_prio>" >&2
        echo >&2
        echo "  command_name: " >&2
        echo ""
        echo "               ecmc_rt ">&2
	echo "               ecmc_rt 90">&2
        echo ""
        echo >&2
        exit 0
fi

if [ -z "${NEWIRQPRIO}" ]; then
      NEWIRQPRIO=80;
fi

check_PREEMPT_RT

declare TID=0;
declare PS_RETURN="";
declare IRQPRIO=0;

#
# tid is the first item of ps result, so awk uses $1 in order to get tid in ps command
# ps -eTo tid,rtprio,nice,cls,pri,cmd c
# 

PS_RETURN=$(return_ps "${CMD}");

if [ ! "${PS_RETURN}"  ]; then
    printf "There is no RT process of %s\n" "${CMD}";
    exit 0
fi


TID=$(echo $PS_RETURN     | awk '{print $1}');
IRQPRIO=$(echo $PS_RETURN | awk '{print $2}');

printf "\n%s IRQ thread priority : Running:%s  Max:%s\n" "${CMD}" "${IRQPRIO}" "${NEWIRQPRIO}";
	
if [ "${TID}xxx" == "xxx" ]; then
    printf "%s IRQ thread not found (OK if not PREEMPT_RT kernel)\n" "${CMD}";
else
    printf "Changing the %s IRQ thread priority from %s to %s\n" "${CMD}" "${IRQPRIO}" "${NEWIRQPRIO}";
    #
    # -f : --fifo : set policy to SCHED_FIFO
    #
    chrt -f -p ${NEWIRQPRIO} ${TID};

    printf "Information on the changed \n";
    return_ps "$CMD"
fi

exit
