

## ip 7-43


```
su

usermod -aG sudo iocuser

sudo apt install git build-essential 

mkdir ics_gitsrc
cd ics_gitsrc
git clone https://github.com/icshwi/e3-tools
cd e3-tools/rt_conf

uname -ar
Linux ip7-43 4.9.0-11-amd64 #1 SMP Debian 4.9.189-3+deb9u2 (2019-11-11) x86_64 GNU/Linux
```

```
bash rt_conf.bash

*************** Warning!!! ***************
*************** Warning!!! ***************
*************** Warning!!! ***************
>
> You should know how to recover them if it doesn't work!
>
> Linux RT Kernel Installation.
> 
> Debian Stretch 9 is detected as Debian stretch 9.11
>> Do you want to continue (y/N)? 
```


Reboot your system in order to use the RT kernel

```
$ uname -ar
Linux ip7-43 4.9.0-11-rt-amd64 #1 SMP PREEMPT RT Debian 4.9.189-3+deb9u2 (2019-11-11) x86_64 GNU/Linux
```


```
rt_conf$ bash rt_testenv_setup.bash
```


## RT Tests

```
cd rt-tests/
$ sudo ./hwlatdetect --duration=60s

hwlatdetect:  test duration 60 seconds
   detector: tracer
   parameters:
        Latency threshold: 10us
        Sample window:     1000000us
        Sample width:      500000us
     Non-sampling period:  500000us
        Output File:       None

Starting test
test finished
Max Latency: Below threshold
Samples recorded: 0
Samples exceeding threshold: 0


iocuser@ip7-43:~/ics_gitsrc/e3-tools/rt_conf/rt-tests$ sudo ./hwlatdetect --duration=3600s
hwlatdetect:  test duration 3600 seconds
   detector: tracer
   parameters:
        Latency threshold: 10us
        Sample window:     1000000us
        Sample width:      500000us
     Non-sampling period:  500000us
        Output File:       None

Starting test
test finished
Max Latency: 11us
Samples recorded: 1
Samples exceeding threshold: 1
ts: 1574947737.936322397, inner:11, outer:0

```