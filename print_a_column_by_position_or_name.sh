#print column by position [Reference: https://stackoverflow.com/questions/19602181/how-to-extract-one-column-of-a-csv-file]
#for 2nd column
awk -F "\"*,\"*" '{print $2}' textfile.csv
cat mycsv.csv | cut -d ',' -f2




#DID NOT WORK
#print column by name [Reference: https://unix.stackexchange.com/questions/25138/how-to-print-certain-columns-by-name]
#Save the following file as t.awk
BEGIN {
    split(cols,out,",")
}
NR==1 {
    for (i=1; i<=NF; i++)
        ix[$i] = i
}
NR>1 {
    for (i in out)
        printf "%s%s", $ix[out[i]], OFS
    print ""
}

$awk -f t.awk -v cols=filed_1_name,field_2_name,field_3_name input_file.csv


NR==1 {
    for (i=1; i<=NF; i++) {
        ix[$i] = i
    }
}
NR>1 {
    print $ix[c1]
}

$awk -f t.awk c1=id input_file.csv
