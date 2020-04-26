#gzip a file (keeping the original file intact)
gzip -c file.csv >zipped_file.gz
gzip -k filename

#gzip a folder
gzip -r folder_name

#For maximum compression [least size, more time required]
gzip -9 filename


#For minimum compression [least time, more size required]
gzip -1 filename

#Source : https://linuxize.com/post/gzip-command-in-linux

