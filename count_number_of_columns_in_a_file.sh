awk '{print NF}' file_name | sort -nu | tail -n 1



#Need to add one with the following:  [Remember: seperator is comma ","]
head -n1 file_name | grep -o "," | wc -l

#Reference: https://stackoverflow.com/questions/5761212/count-number-of-columns-in-bash
