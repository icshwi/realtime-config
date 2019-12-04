
declare -gr SUDO_CMD="sudo";

declare -g KERNEL_VER=$(uname -r)

declare -g GRUB_CONF=grub_centos
#declare -g GRUB_CONF=grub

declare -g SED="sed i~"


function find_existent_boot_parameter
{

    local GRUB_CMDLINE_LINUX
    eval $(cat ${GRUB_CONF} | grep -E "^(GRUB_CMDLINE_LINUX)=")
    echo "${GRUB_CMDLINE_LINUX}"
 
}

grub_cmdline_linux="$(find_existent_boot_parameter)"
rt_cmdline_linux="idle=poll intel_idle.max_cstate=0 processor.max_cstate=1 skew_tick=1"

grub_cmdline_linux+=${rt_cmdline_linux}



echo $grub_cmdline_linux

new_cmdline_linux=\"${grub_cmdline_linux}\"

sed "s|^GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX=${new_cmdline_linux}|g" ${GRUB_CONF}


# ${SED} \"s|^${old_param}|${new_param}|g\"  ${GRUB_CONF}


