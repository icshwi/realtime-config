

camonitor  IOC_TEST:MCU-thread-latency-max  | awk -f RunningAverage.awk


# How to make csv file
```
camonitor -F,  IOC_TEST:MCU-thread-latency-max  > 1.csv
```


# Run ROOT to check it. 
``

$ root 
   ------------------------------------------------------------
  | Welcome to ROOT 6.18/04                  https://root.cern |
  |                               (c) 1995-2019, The ROOT Team |
  | Built for linuxx8664gcc on Oct 09 2019, 10:05:00           |
  | From tags/v6-18-04@v6-18-04                                |
  | Try '.help', '.demo', '.license', '.credits', '.quit'/'.q' |
   ------------------------------------------------------------

root [0] .L analyze.C
root [1] saveRootFile()
root [1] plot()
root [2] plot(1000,30)
root [3] plot(3000)
root [4] plot(5000, 5000)
```

```
$ root
root [0] new TBrowser
```

## Notice
More than 10k points, it needs more time to plot time series graph. But Histtogram will be shown up quickly (less than 10s) than the graph (.



