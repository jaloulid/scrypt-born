#!/bin/bash

# Gather system stats
arch=$(uname -a)
cpuf=$(grep -c "physical id" /proc/cpuinfo)
cpuv=$(grep -c "processor" /proc/cpuinfo)
ram=$(free -m | awk '/Mem:/ {printf "%d/%dMB (%.2f%%)", $3, $2, $3/$2*100}')
disk=$(df -h --total | awk '/^total/ {printf "%s/%s (%s)", $3, $2, $5}')
cpu_load=$(awk -v idle=$(vmstat 1 2 | tail -1 | awk '{print $15}') 'BEGIN {printf "%.1f%%", 100-idle}')
last_boot=$(who -b | awk '{print $3, $4}')
lvmu=$(lsblk | grep -q "lvm" && echo "yes" || echo "no")
tcpc=$(ss -t | grep -c ESTAB)
ulog=$(users | wc -w)
network=$(ip a | awk '/inet / && !/127.0.0.1/ {print $2}')
mac=$(ip link | awk '/ether/ {print $2}')
sudo_cmd=$(sudo journalctl _COMM=sudo | grep -c COMMAND)

# Display the information
wall "Architecture: $arch
CPU Physical: $cpuf
vCPU: $cpuv
Memory Usage: $ram
Disk Usage: $disk
CPU Load: $cpu_load
Last Boot: $last_boot
LVM Use: $lvmu
TCP Connections: $tcpc ESTABLISHED
Logged-in Users: $ulog
Network: $network (MAC: $mac)
Sudo Commands: $sudo_cmd"

