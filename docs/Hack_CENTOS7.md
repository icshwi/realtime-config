
## Hack for the latest CentOS7

* Remove all tuned version

```
yum remove tuned tuned-gtk tuned-profiles-atomic tuned-profiles-compat tuned-profiles-cpu-partitioning tuned-profiles-nfv tuned-profiles-nfv-guest tuned-profiles-nfv-host tuned-profiles-oracle tuned-profiles-realtime tuned-profiles-sap tuned-profiles-sap-hana tuned-utils  tuned-utils-systemtap 
```


* Check all packages of RT group
```
[root@e3vmc75 Downloads]# yum groupinfo RT
Loaded plugins: fastestmirror, langpacks
Repository rt is listed more than once in the configuration
Repository rt-debug is listed more than once in the configuration
Repository rt-source is listed more than once in the configuration
Loading mirror speeds from cached hostfile
 * base: mirror.hh.se
 * epel: mirror.netsite.dk
 * extras: mirror.hh.se
 * updates: mirror.hh.se

Group: RealTime
 Group-Id: RT
 Description: RealTime for CERN CentOS 7
 Default Packages:
   +kernel-rt
   +rt-setup
   +rt-tests
   +rtcheck
   +rtctl
   +rteval
   +rteval-common
   +rteval-loads
```

* Remove all RT packages

```
yum remove kernel-rt rt-setup rtcheck rtctl rteval rteval-common rteval-loads
```


* Install the specific version of tuned
```
yum install tuned-profiles-realtime-2.8.0-5.el7_4.2 yum-plugin-versionlock
```

* lock the version of tuned
```
yum versionlock tuned tuned-profiles-realtime
```