for i in `find . -type d`
do
     
     cat $i/* >"$i.csv"
done
