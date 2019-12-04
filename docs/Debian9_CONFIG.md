```
sudo systemctl stop anacron.timer
sudo systemctl disable anacron.timer
Removed /etc/systemd/system/timers.target.wants/anacron.timer.
sudo systemctl mask anacron.timer
Created symlink /etc/systemd/system/anacron.timer → /dev/null.


iocuser@ip7-21:~/ics_gitsrc/e3-tools/rt_conf$ sudo systemctl stop apt-daily-upgrade.timer
iocuser@ip7-21:~/ics_gitsrc/e3-tools/rt_conf$ sudo systemctl disable apt-daily-upgrade.timer
Removed /etc/systemd/system/timers.target.wants/apt-daily-upgrade.timer.
iocuser@ip7-21:~/ics_gitsrc/e3-tools/rt_conf$ sudo systemctl mask apt-daily-upgrade.timer
Created symlink /etc/systemd/system/apt-daily-upgrade.timer → /dev/null.
iocuser@ip7-21:~/ics_gitsrc/e3-tools/rt_conf$ sudo systemctl stop apt-daily.timer
iocuser@ip7-21:~/ics_gitsrc/e3-tools/rt_conf$ sudo systemctl disable apt-daily.timer
Removed /etc/systemd/system/timers.target.wants/apt-daily.timer.
iocuser@ip7-21:~/ics_gitsrc/e3-tools/rt_conf$ sudo systemctl mask apt-daily.timer
Created symlink /etc/systemd/system/apt-daily.timer → /dev/null.
iocuser@ip7-21:~/ics_gitsrc/e3-tools/rt_conf$ sudo systemctl stop sound
iocuser@ip7-21:~/ics_gitsrc/e3-tools/rt_conf$ sudo systemctl stop sound.target
iocuser@ip7-21:~/ics_gitsrc/e3-tools/rt_conf$ sudo systemctl disable sound.target
iocuser@ip7-21:~/ics_gitsrc/e3-tools/rt_conf$ sudo systemctl mask sound.target
Created symlink /etc/systemd/system/sound.target → /dev/null.




anacron.timer
apt-daily-upgrade.timer
apt-daily.timer
sound.target
alsa-restore
```
