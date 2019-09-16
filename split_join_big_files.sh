#If file is big in size split it vertically from shell / bash commands use the following commans as a reference to split huge files vertically into chunks (Reference: http://www.unixcl.com/2009/10/awk-split-file-vertically-on-columns.html)
#The following code will create 2 files from file.txt which has 9 columns. The first file will have columns 1 to 3 and the second column will have columns 4 to 9
#$cut -d"," -f1-3 file.txt >file_col1_to_3.txt
#$cut -d"," -f4-9 file.txt >file_col4_to_9.txt
#$cut -d$"\t" -f4-9 tsv_file.tsv >tsv_file_col4_to_9.tsv ##splitting tsv files
#To rejoin and get back the original file use the following bash/shell command
#$paste -d "," file_col1_to_3.txt file_col4_to_9.txt >merged_file.txt
