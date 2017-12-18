#Find out if blocks are missing

hdfs fsck / | egrep -v '^\.+$' | grep -v eplica
hdfs fsck /path/to/corrupt/file -locations -blocks -files

#Delete the missing block
hdfs fs -rm /path/to/file/with/permanently/missing/blocks

#Reference: https://stackoverflow.com/questions/19205057/how-to-fix-corrupt-hdfs-files
