#Select random samples / lines from a file:    
shuf -n N input_file.txt >output_file.txt  
#[ N is the umber of n is the number of lines to be selected randomly]
#Reference: https://unix.stackexchange.com/questions/108581/how-to-randomly-sample-a-subset-of-a-file

#Select random lines from a file without header / column names:
sed '1d' input_file.txt | shuf -n N >output_file.txt
#[ N is the umber of n is the number of lines to be selected randomly]
