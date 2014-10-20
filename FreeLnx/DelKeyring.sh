#!/bin/sh
# Remove login keyring

log=/mnt/SYSTEM.SAV/install.log

echo "Begin delete keyring..." >> $log
rm -f /home/user/.gnome2/keyrings/login.keyring
rm -f /etc/skel/.gnome2/keyrings/login.keyring
echo "End delete keyring..." >> $log

