camonitor -F,  IOC_TEST:MCU-thread-latency-max  > 1.csv

camonitor  IOC_TEST:MCU-thread-latency-max  | awk -f RunningAverage.awk
