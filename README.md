Linux RT PREEMPT Kernel Installation and Configuration
===

In the simple script, one can change a normal kernel to a Realtime PREEMPT kernel in Debian 9 and CentOS7.


# Commands

## Debian 9 and Community CentOS 7
```
bash rt_conf.bash
```

## ESS CentOS 7
I don't recommend this script, please contact relevant persons to ask the real time kernel support. 
Even so, one would like to try this script (It may switch the entire environment to the generic one, 
one can revert these changes manually. There is no support on them.), please run the script with an argument as follows:

```
bash rt_conf.bash clean
```

# Packages

## Remove unnecessary packages
* postfix
* sendmail
* cups

## Install maybe necessary packages
* ethtool

# Install RT Kernel image and header files

Current CentOS repositories have the broken dependency issues. This approach is weird, but
we need to move forward. Please use the generic CentOS 7.  

## Debian 9
Use the default Debian repository

## CentOS 7
* Use the CERN CentOS 7 rt repository [1]. Note that CentOS 7 should be generic one. 
* Disable all repositories in order to keep the one RT kernel
```
$ yum repolist
$ yum-config-manager --disable \*
$ yum repolist
Loaded plugins: fastestmirror, versionlock
repolist: 0
```
* Set the default kernel to the RT kernel
```
$ grubby --set-default-kernel=/boot/vmlinuz-3.10.0-1062.9.1.rt56.1033.el7.x86_64
```
One can check the default one via
```
$ grubby --default-kernel
```

# Tuning the Kernel boot parameters

According to the Reference [2], we select the minimum boot parameters as follows:

* idle=pool (with the assumption that TSC is selected as the system clock source)
* intel_idle.max_cstate=0
* processor.max_cstate=1
* skew_tick=1

# Clock Source

The tuned kernel boot parameters have the requirement of TSC clock. Please check it
and select TSC if not. 

* Check the current clock source
```
cat /sys/devices/system/clocksource/clocksource0/current_clocksource
```
* Check the available clock source
```
cat /sys/devices/system/clocksource/clocksource0/available_clocksource
```
* Select the tsc (Time Stamp Counter) [2] as the current clock
```
echo tsc > /sys/devices/system/clocksource/clocksource0/current_clocksource
```

# Additional Tuning

## CLI
```
$ systemctl get-default
graphical.target
$ systemctl set-default multi-user.target
$ reboot
```

## BIOS 

Disable Power Saving and other features.

## irqbalance

At the baseline of the configuration, we would like **not** to use the irqbalance with Linux PREEMPT RT kernel. Note that one should check its status via `systemctl status irqbalance` after rebooting with RT kernel. Or one can use `rt_check.bash`. 

```
>>> System service : irqbalance
● irqbalance.service - irqbalance daemon
   Loaded: loaded (/usr/lib/systemd/system/irqbalance.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
```

# References

[1] http://linux.web.cern.ch/linux/centos7/  
[2] https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_for_real_time/7/  
[3] https://en.wikipedia.org/wiki/Time_Stamp_Counter  
