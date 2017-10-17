#Keep only those lines of file old_file.csv which contains 27 fileds
awk -F ',' 'NF==27' <old_file.csv >new_file.csv
