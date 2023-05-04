#!/bin/sh 
# mysql_backup.sh: backup mysql databases and keep newest 5 days backup. 
# 
# db_user is mysql username 
# db_passwd is mysql password 
# db_host is mysql host 
# 20140818 by Mr.shazi
# ————————————————————————————————————————
db_user="root" 
db_passwd=$MYSQL_ROOT_PASSWORD
db_host=$MYSQL_CONTAINER_NAME

# the directory for story your backup file. 
backup_dir=$MYSQL_BACKUP_FOLDER
backup_file_prefix=$MYSQL_BACKUP_FILE_PREFIX

# date format for backup file (dd-mm-yyyy) 
time="$(date +"%Y-%m-%d_%H_%M_%S")"
today="$(date +"%Y-%m-%d")"
fpath=$backup_dir$today
echo $fpath 
if [ ! -d $fpath ];then
mkdir $fpath
fi 

# mysql, mysqldump and some other bin's path 
MYSQL=$(which mysql)
MYSQLDUMP=$(which mysqldump)
MKDIR="/bin/mkdir" 
RM="/bin/rm" 
MV="/bin/mv" 
GZIP=$(which gzip) 

# the directory for story the newest backup 
test ! -d "$backup_dir/bk/" && $MKDIR "$backup_dir/bk/" 

# check the directory for store backup is writeable 
test ! -w $backup_dir && echo "Error: $backup_dir is un-writeable." && exit 0 

# get all databases 
all_db="$($MYSQL -u $db_user -h $db_host -p$db_passwd -Bse 'show databases')" 
for db in $all_db 
do 
$MYSQLDUMP -u $db_user -h $db_host -p$db_passwd $db --single-transaction | $GZIP -9 > "$fpath/$db.$time.gz" 
done 

#
cd $backup_dir
tar czf MySQL.$backup_file_prefix.$time.tar.gz $today
rm -rf $today
mv MySQL.$backup_file_prefix.$time.tar.gz $backup_dir/bk/

#scp backup to other server
#scp $backup_dir/bk/Mysql.$time.tar.gz root@192.168.0.1:/volume/backup/bak/

# delete the oldest backup 
#find $backup_dir -type f -mtime +4 -name "*.gz" -exec rm -f {} \; 
find $backup_dir/bk -name "*.gz" -type f -mtime +5 -exec rm -f {} \; > /dev/null 2>&1

exit 0;
