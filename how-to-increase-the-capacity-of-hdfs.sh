#Source: https://community.hortonworks.com/questions/21687/how-to-increase-the-capacity-of-hdfs.html
The best way is to create a new mount point and point it to a folder in the /home. Therefore create a mount point eg. Hdfsdata and then point it to a folder under home, eg. /home/hdfsdata. Following are the steps to create a new mount point:

Create a folder in the root eg. /hdfsdata Create a folder under home eg. /home/hdfsdata
Provide permission to 'hdfs' user to this folder: chown hdfs:hadoop -R /home/hdfsdata
Provide file/folder permissions to this folder: chmod 777 -R /home/hdfsdata.
Mount this new folder mount --bind /home/hdfsdata/ /hdfsdata/

