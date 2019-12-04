Command Collection
==


## Get the tid of ecmc_rt

```
$ ps -eTo pid,tid,rtprio,cls,pri,cmd c | grep -v grep | sort -n

11011 11011      1  FF  41 softIocPVA
11011 11014     10  FF  50 errlog
11011 11015     59  FF  99 timerQueue
11011 11016     59  FF  99 timerQueue
11011 11017     50  FF  90 MC_CPU1
11011 11018     10  FF  50 taskwd
11011 11020     50  FF  90 MCU1
11011 11022     10  FF  50 motorPoller
11011 11024     90  FF 130 ecmc_rt
11011 11026     69  FF 109 timerQueue
11011 11027     58  FF  98 cbLow
11011 11028     63  FF 103 cbMedium
11011 11029     70  FF 110 cbHigh
11011 11030     50  FF  90 dbCaLink
11011 11031     50  FF  90 PVAL
11011 11032     49  FF  89 soft_motor
11011 11033     10  FF  50 timerQueue
11011 11034     19  FF  59 PDB-event
11011 11035     35  FF  75 pvAccess-client
11011 11036     50  FF  90 UDP-rx 0.0.0.0:
11011 11037     50  FF  90 UDP-rx 192.168.
11011 11038     50  FF  90 UDP-rx 192.168.
11011 11039     50  FF  90 UDP-rx 224.0.0.
11011 11040     66  FF 106 scanOnce
11011 11041     59  FF  99 scan-10
11011 11042     60  FF 100 scan-5
11011 11043     61  FF 101 scan-2
11011 11044     62  FF 102 scan-1
11011 11045     63  FF 103 scan-0.5
11011 11046     64  FF 104 scan-0.2
11011 11047     65  FF 105 scan-0.1
11011 11048     16  FF  56 CAS-TCP
11011 11049     12  FF  52 CAS-UDP
11011 11050     14  FF  54 CAS-beacon
11011 11051     10  FF  50 ipToAsciiProxy
11011 11052     51  FF  91 timerQueue
11011 11053     53  FF  93 CAC-UDP
11011 11054     51  FF  91 CAC-event
11011 11055     25  FF  65 PVAS timers
11011 11056     50  FF  90 TCP-acceptor
11011 11057     50  FF  90 UDP-rx 0.0.0.0:
11011 11058     50  FF  90 UDP-rx 192.168.
11011 11059     50  FF  90 UDP-rx 192.168.
11011 11060     50  FF  90 UDP-rx 224.0.0.
11023 11023      -  TS  19 EtherCAT-OP


```

## Change the Scheduling Policy

```
$ chrt -f -p 80 10071
```
, where 80 is the `rtprio` and 10071 is `tid`, and `-f` is the `SCHED_FIFO`


## More rich info

```
$ ps -e -L -o cpuid,pid,lwp,state,pri,tid,rtprio,class,wchan:30,comm
    0 10980 10980 S  19 10980      - TS  do_wait                        iocsh.bash
    0 11011 11011 S  41 11011      1 FF  n_tty_read                     softIocPVA
    0 11011 11014 S  50 11014     10 FF  futex_wait_queue_me            errlog
    0 11011 11015 S  99 11015     59 FF  futex_wait_queue_me            timerQueue
    0 11011 11016 S  99 11016     59 FF  futex_wait_queue_me            timerQueue
    0 11011 11017 S  90 11017     50 FF  futex_wait_queue_me            MC_CPU1
    0 11011 11018 S  50 11018     10 FF  futex_wait_queue_me            taskwd
    0 11011 11020 S  90 11020     50 FF  futex_wait_queue_me            MCU1
    0 11011 11022 S  50 11022     10 FF  futex_wait_queue_me            motorPoller
    0 11011 11024 S 130 11024     90 FF  hrtimer_nanosleep              ecmc_rt
    0 11011 11026 S 109 11026     69 FF  futex_wait_queue_me            timerQueue
    0 11011 11027 S  98 11027     58 FF  futex_wait_queue_me            cbLow
    0 11011 11028 S 103 11028     63 FF  futex_wait_queue_me            cbMedium
    0 11011 11029 S 110 11029     70 FF  futex_wait_queue_me            cbHigh
    0 11011 11030 S  90 11030     50 FF  futex_wait_queue_me            dbCaLink
    0 11011 11031 S  90 11031     50 FF  futex_wait_queue_me            PVAL
    0 11011 11032 S  89 11032     49 FF  futex_wait_queue_me            soft_motor
    0 11011 11033 S  50 11033     10 FF  futex_wait_queue_me            timerQueue
    0 11011 11034 S  59 11034     19 FF  futex_wait_queue_me            PDB-event
    0 11011 11035 S  75 11035     35 FF  futex_wait_queue_me            pvAccess-client
    0 11011 11036 S  90 11036     50 FF  skb_wait_for_more_packets      UDP-rx 0.0.0.0:
    0 11011 11037 S  90 11037     50 FF  skb_wait_for_more_packets      UDP-rx 192.168.
    0 11011 11038 S  90 11038     50 FF  skb_wait_for_more_packets      UDP-rx 192.168.
    0 11011 11039 S  90 11039     50 FF  skb_wait_for_more_packets      UDP-rx 224.0.0.
    0 11011 11040 S 106 11040     66 FF  futex_wait_queue_me            scanOnce
    0 11011 11041 S  99 11041     59 FF  futex_wait_queue_me            scan-10
    0 11011 11042 S 100 11042     60 FF  futex_wait_queue_me            scan-5
    0 11011 11043 S 101 11043     61 FF  futex_wait_queue_me            scan-2
    0 11011 11044 S 102 11044     62 FF  futex_wait_queue_me            scan-1
    0 11011 11045 S 103 11045     63 FF  futex_wait_queue_me            scan-0.5
    0 11011 11046 S 104 11046     64 FF  futex_wait_queue_me            scan-0.2
    0 11011 11047 S 105 11047     65 FF  futex_wait_queue_me            scan-0.1
    0 11011 11048 S  56 11048     16 FF  inet_csk_accept                CAS-TCP
    0 11011 11049 S  52 11049     12 FF  skb_wait_for_more_packets      CAS-UDP
    0 11011 11050 S  54 11050     14 FF  hrtimer_nanosleep              CAS-beacon
    0 11011 11051 S  50 11051     10 FF  futex_wait_queue_me            ipToAsciiProxy
    0 11011 11052 S  91 11052     51 FF  futex_wait_queue_me            timerQueue
    0 11011 11053 S  93 11053     53 FF  skb_wait_for_more_packets      CAC-UDP
    0 11011 11054 S  91 11054     51 FF  futex_wait_queue_me            CAC-event
    0 11011 11055 S  65 11055     25 FF  futex_wait_queue_me            PVAS timers
    0 11011 11056 S  90 11056     50 FF  inet_csk_accept                TCP-acceptor
    0 11011 11057 S  90 11057     50 FF  skb_wait_for_more_packets      UDP-rx 0.0.0.0:
    0 11011 11058 S  90 11058     50 FF  skb_wait_for_more_packets      UDP-rx 192.168.
    0 11011 11059 S  90 11059     50 FF  skb_wait_for_more_packets      UDP-rx 192.168.
    0 11011 11060 S  90 11060     50 FF  skb_wait_for_more_packets      UDP-rx 224.0.0.
    0 11023 11023 S  19 11023      - TS  ec_master_operation_thread     EtherCAT-OP

```
