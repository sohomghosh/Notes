awk -F ',' '{print NF}' data.csv |sort|uniq -c
