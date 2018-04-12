#To see number of cores
nproc

#To see ram usage
top
free -mh

#HardDisk
df -lk

#Disk usage
du

#HDD to SSD verify for linux
cat /sys/block/sda/queue/rotational
#You should get 1 for hard disks and 0 for a SSD. Reference: https://unix.stackexchange.com/questions/65595/how-to-know-if-a-disk-is-an-ssd-or-an-hdd

