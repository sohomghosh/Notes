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
 


#To view cronjobs
crontab -e

#cronjob running all times with log
* * * * * /index/file_to_run.ksh > /index/output.log 2>&1
