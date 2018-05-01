#create a tar.gz fie from a folder
tar -zcvf tar-archive-name.tar.gz source-folder-name 

#create a tar.gz fie from a file fname.csv
tar -zcvf fname.tar.gz fname.csv

#extract a tar.gz file
tar -zxvf tar-archive-name.tar.gz 

#You can use unxz command to extract .xz files  [this is a file has extension .xz and NOT tar.xz]:
unxz file.xz
