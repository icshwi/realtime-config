Linux RT PREEMPT Kernel Installation and Configuration
===

In the simple script, one can change a normal kernel to a Realtime PREEMPT kernel in Debian 9 and CentOS7.


# Commmands

## Debian 9 and Community CentOS 7
```
bash rt_conf.bash
```

## ESS CentOS 7
I don't recommend this script, please contact relevant persons to ask the real time kernel support. 
Even if one would like to try this script (It will switch the entire environment to the generic one, 
one cannot revert these changes), run the script with an argument as follows:

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
Use the CERN CentOS 7 rt repository [1]. Note that CentOS 7 should be generic one. 


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

At the baseline of the configuration, we would like to use the irqbalance with Linux PREEMPT RT kernel. Note that one should check its status via `systemctl status irqbalance` after rebooting with RT kernel. 


# References

[1] http://linux.web.cern.ch/linux/centos7/  
[2] https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_for_real_time/7/  
[3] https://en.wikipedia.org/wiki/Time_Stamp_Counter  
