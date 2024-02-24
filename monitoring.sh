#_______________________all the infos about architecture_____________________+
architecture=$(uname -a)
#_________________the pysical cpu (pysical cores)____________________________+
CPU=$(lscpu | grep 'Socket(s):' | awk '{print $2}')
#______________________vertual CPUs_________________________________________+
vCPU=$(nproc)
#__________________Total RAM________________________________________________+
T_ram=$(free -m | grep 'Mem:' | awk '{print $2}')
#_______________________Used RAM____________________________________________+
U_ram=$(free -m | grep 'Mem:' | awk '{print $3}')
#_________________the RAM infos as a percentage format______________________+
P_ram=$(free -m | awk '$1 == "Mem:"{printf("(%.2f)"), $3/$2*100}')
#_______________________DISK Infos__________________________________________+
used_storage=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_use += $3} END {print memory_use}')
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{total += $2} {used += $3} END {printf ("%d%%"), used/total*100}')
#_________________how much percent used in CPU_____________________________+
CPU_load=$(mpstat | grep all | awk '{printf("%.1f%%\n",100-$13)}')
#______________________The Last reboot Date________________________________+
last_reboot=$(last reboot | head -1 | awk '{print $5, $6, $7, $8}')
#__________________is the logical volumes active or not____________________+
lvm_number=$(lsblk | grep "lvm" | wc -l)
lvm=$(if [ $lvm_number -eq 0 ]; then echo no; else echo yes;fi)
#_____________________The number of connections STABILISHED________________+
connections=$(netstat | grep ESTABLISHED | wc -l)
#__________________the number of users connected to this server____________+
users=$(users | uniq | wc -w)
#______________________the IPV4 of the server and its MAC___________________+
IPv4=$(ip link | grep link/ether | awk  '{print $2}')
#_______________________The number of commands excuted with sudo program____+
Sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
#===========================================================================
wall "
		#architecture: $architecture
		#CPU physical : $CPU
		#vCPU : $vCPU
		#Memory Usage: $U_ram/$T_ram MB $P_ram%
		#Disk Usage: $used_storage/$disk_total GB  ($percent)
		#CPU load: $CPU_load
		#Last boot: $last_reboot
		#LVM: $lvm
		#connections TCP : $connections ESTABLISHED
		#User log : $users
		#Network: IP $(hostname -I) ($IPv4)
		#Sudo : $Sudo cmd"
