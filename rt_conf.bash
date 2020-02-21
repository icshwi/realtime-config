#!/usr/bin/env bash
#
#  Copyright (c) 2018 - 2019 Jeong Han Lee
#  Copyright (c) 2018 - 2019 European Spallation Source ERIC
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
# Date    : Thursday, December  19 10:54:19 CET 2019
#
# version : 0.2.2

# Only aptitude can understand the extglob option
shopt -s extglob

declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_SCRIPTNAME=${0##*/}
declare -gr SC_TOP="${SC_SCRIPT%/*}"
declare -gr SC_LOGDATE="$(date +%y%m%d%H%M)"

declare -gr SUDO_CMD=$(which sudo);
  
declare -g KERNEL_VER=$(uname -r)

declare -g GRUB_CONF=/etc/default/grub
#declare -g GRUB_CONF=${SC_TOP}/grub

declare -g SED="sed"



. ${SC_TOP}/.cfgs/.functions



function centos_restore_generic_repo
{
    local clean_ess=$1; shift;
    local bservice="";
    if [ "$clean_ess" = "clean" ]; then
	
	for bservice in ${essvm_services[@]}; do
	    mask_system_service $bservice
	done
	
	${SUDO_CMD} rm -rf /etc/yum.repos.d/{ESS-*,elastic-*,zabbix-*}
	${SUDO_CMD} rm -rf /etc/yum.repos.d/CentOS-{Media,Vault}.repo
	${SUDO_CMD} yum clean all
	${SUDO_CMD} rm -rf /var/chache/yum
	${SUDO_CMD} sed -i "s|^enabled.*|enabled=1|" /etc/yum.repos.d/*
	${SUDO_CMD} yum update -y 
	${SUDO_CMD} yum install -y centos-release
    fi
}


function centos_rt_conf
{
    local user=$(whoami);
    
    ${SUDO_CMD} tee /etc/yum.repos.d/CentOS-rt.repo >/dev/null <<"EOF"
#
#
# CERN CentOS 7 RealTime repository at http://linuxsoft.cern.ch/
#

[rt]
name=CentOS-$releasever - RealTime
baseurl=http://linuxsoft.cern.ch/cern/centos/$releasever/rt/$basearch/
gpgcheck=1
enabled=1
protect=1
priority=10
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-cern

[rt-debug]
name=CentOS-$releasever - RealTime - Debuginfo
baseurl=http://linuxsoft.cern.ch/cern/centos/$releasever/rt/Debug/$basearch/
gpgcheck=1
enabled=0
protect=1
priority=10
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-cern

[rt-source]
name=CentOS-$releasever - RealTime - Sources
baseurl=http://linuxsoft.cern.ch/cern/centos/$releasever/rt/Sources/
gpgcheck=1
enabled=0
protect=1
priority=10
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-cern

EOF

    ${SUDO_CMD} rpm --import http://linuxsoft.cern.ch/cern/centos/7/os/x86_64/RPM-GPG-KEY-cern
 
    ${SUDO_CMD} yum update -y
    #
    # Somehow linuxsoft.cern.ch and CentOS doesn't have tuned 2.9.0 version, so
    # update repo has 2.10.0, without the fixed version we cannot install RT group,
    # so, we fixed the version 2.8.0 first on tuned. 
    #
    ${SUDO_CMD} yum -y remove  "tuned-*"
    ${SUDO_CMD} yum -y install tuna yum-plugin-versionlock 
    ${SUDO_CMD} yum -y install --disablerepo="*" --enablerepo="rt" tuned-profiles-realtime-2.8.0-5.el7_4.2
    ${SUDO_CMD} yum versionlock tuned tuned-profiles-realtime
    ${SUDO_CMD} yum -y install kernel-rt rt-setup rtcheck rtctl rteval rteval-common rteval-loads kernel-rt-devel

    # After the rt configuration, CentOS has 'realtime' group.
    # We need to only add the current user to the realtime group.
    add_user_to_group "$user" "realtime";
}


function add_realtime_debian
{
    local user="$1"; shift;
    create_group "realtime";
    add_user_to_group "$user" "realtime";
}



function debian_rt_conf
{
    # apt, apt-get cannot handle extglob, so aptitude
    # in order to exclude -dbg kernel image. However, aptitude install
    # doesn't understand extglob, only search can do.

    local user=$(whoami);
    rt_image=$(aptitude search linux-image-rt!(dbg) | awk '{print $2}')
    ${SUDO_CMD} apt install -y linux-headers-rt* ${rt_image}
    #
    # create the realtime group and add the current user to realtime group
    #
    add_realtime_debian $user;

    ${SUDO_CMD} install -m 644 ${SC_TOP}/conf/realtime.conf /etc/security/limits.d/
    
}

function centos_pkgs
{
    local remove_pkg_name="postfix sendmail";
    printf "Removing .... %s\n" ${remove_pkg_name}
    ${SUDO_CMD} yum -y remove postfix sendmail cups
    printf "Installing .... ethtool\n";
    ${SUDO_CMD} yum -y install ethtool numactl-devel yum-utils
}

function debian_pkgs
{
    local remove_pkg_name="postfix sendmail";
    printf "Removing .... %s\n" ${remove_pkg_name}
    ${SUDO_CMD} apt remove -y postfix sendmail cups
    printf "Installing .... ethtool\n";
    ${SUDO_CMD} apt install -y aptitude ethtool build-essential libnuma-dev 
}


function boot_parameters_conf
{

    local grub_cmdline_linux="$(find_existent_boot_parameter)"
    # 
    # idle=pool               : forces the TSC clock to aviod entering the idle state
    # processor.max_cstate=1  : prevents the clock from entering deeper C-states (energy saving mode), so it does not become out of sync
    # intel_idle.max_cstate=0 : ensures sleep states are not entered:
    # skew_tick=1             : Reduce CPU performace spikes
    # * Red Hat Enterprise Linux for Real Time 7 Tuning Guide
    # * https://gist.github.com/wmealing/2dd2b543c4d3cff6cab7

    local rt_boot_parameter="idle=poll intel_idle.max_cstate=0 processor.max_cstate=1 skew_tick=1"

    existent_cmdline=${grub_cmdline_linux}
    drop_cmdline_linux="${rt_boot_parameter}"
    
    grub_cmdline_linux=$(drop_from_path "${existent_cmdline}" "${drop_cmdline_linux}")


    grub_cmdline_linux+=" "
    grub_cmdline_linux+=${rt_boot_parameter}
    new_grub_cmdline_linux=\"${grub_cmdline_linux}\"

    echo ${new_grub_cmdline_linux}

    printf "\n\n";
    printf ">>>>>\n";
    printf "     We are adding %s into GRUB_CMDLINE_LINUX in the file %s.\n" "${rt_boot_parameter}" "${GRUB_CONF}"
    printf "     If something goes wrong, you can revert them with the backup file, e.g., grub.bk\n"
    printf "     Please check grub.bk in the %s\n" "${GRUB_CONF%/*}/"
    printf ">>>>>\n\n"

    ${SUDO_CMD} cp -b ${GRUB_CONF} ${GRUB_CONF%/*}/grub.bk

    ${SED} "s|^GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX=${new_grub_cmdline_linux}|g" ${GRUB_CONF} | ${SUDO_CMD} tee ${GRUB_CONF}  >/dev/null

}


function printf_tee
{
    local input=${1};
    local target=${2};
    # If target exists, it will be overwritten.
    ${SUDO_CMD} printf "%s" "${input}" | ${SUDO_CMD} tee "${target}";
};


function tuned_configure
{
    
    local target="/etc/tuned/realtime-variables.conf"
    local rule="isolated_cores=0"

    printf_tee "$rule" "$target";

    ${SUDO_CMD} tuned-adm profile realtime
}

ANSWER="NO"

dist=$(find_dist)
echo "DISTRIBUTION: $dist"
case "$dist" in
    *"stretch"*)
	if [ "$ANSWER" == "NO" ]; then
	    yes_or_no_to_go "Debian Stretch 9 is detected as $dist"
	fi
	debian_pkgs
	debian_rt_conf
	boot_parameters_conf
	${SUDO_CMD} update-grub
	;;
    *"CentOS Linux 7"*)
	if [ "$ANSWER" == "NO" ]; then
	    yes_or_no_to_go "CentOS Linux 7 is detected as $dist"
	fi
	centos_restore_generic_repo "$1"
	centos_pkgs;
	centos_rt_conf;
	add_user_rtgroup;
	boot_parameters_conf
	# There is a possible change in UEFI and legacy, so
	# we keep both if we see EFI path
	# 
	if [ -d "/system/firmware/efi" ]; then
	    ${SUDO_CMD} grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
	fi
	${SUDO_CMD} grub2-mkconfig -o /boot/grub2/grub.cfg
	
	;;
    *"CentOS Core 7"*)
	if [ "$ANSWER" == "NO" ]; then
	    yes_or_no_to_go "CentOS Linux 7 is detected as $dist"
	fi
	centos_restore_generic_repo "$1"
	centos_pkgs;
	centos_rt_conf;
	add_user_rtgroup;
	boot_parameters_conf
	# There is a possible change in UEFI and legacy, so
	# we keep both if we see EFI path
	# 
	if [ -d "/system/firmware/efi" ]; then
	    ${SUDO_CMD} grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
	fi
	${SUDO_CMD} grub2-mkconfig -o /boot/grub2/grub.cfg
	
	;;

    *)
	printf "\n";
	printf "Doesn't support the detected $dist\n";
	printf "Please contact jeonghan.lee@gmail.com\n";
	printf "\n";
	exit;
	;;
esac


for aservice in ${common_services[@]}; do
    mask_system_service $aservice
done

tuned_configure

printf "\n"
printf "Reboot your system in order to use the RT kernel\n";
printf "\n"

exit
