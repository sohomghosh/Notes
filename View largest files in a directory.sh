#Find largest files
sudo du -a / | sort -n -r | head -n 100

#See disk usgae for a directory
df -h /<directory_name>
