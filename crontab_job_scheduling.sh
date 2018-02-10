
vi file_to_run.ksh
#The following lines from line number 5 to line number 16 is placed in file file_to_run.ksh

#Points to remember while making .ksh file for cron
source ~/.bashrc
set +x
hadoop fs -ls /index/ >'/index/hadoop_existence.log'
flag=`grep 'Error: line' /index/hadoop_existence.log | wc -l`

if [ ${flag} = 1 ]
then
  #do stuffs here
else
   echo "all right"
fi
 






chmod + x file_to_run.ksh

#To view cronjobs
crontab -e

#cronjob running all times with log : Remember we need to mention full path before the filename, file_to_run.ksh in this case 
* * * * * /index/file_to_run.ksh > /index/output.log 2>&1

#Running at 1 am regularly
0 1 * * * /index/file_to_run.ksh > /index/output.log 2>&1

#Format
Minute Hour Day_of_month Month_of_day day_of_week /index/file_to_run.ksh > /index/output.log 2>&1

#Reference: https://crontab.guru/every-day-at-1am
