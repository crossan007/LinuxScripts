#!/bin/bash
function update {
rm BackupScript* id_rsa
wget http://172.30.9.100/BackupScript.sh
wget http://172.30.9.100/id_rsa
chmod a+x BackupScript.sh
chmod 0700 id_rsa
./BackupScript.sh
echo "0,15,30,45 * * * * /root/BackupScript.sh" 
}

BACKUP_TARGET_HOST=172.30.9.100
BACKUP_TARGET_USERNAME=fcc
BACKUP_TARGET_ROOT=/Server-01-Pool/Shares/FCC/Backups
BACKUP_TARGET_FOLDER=`hostname`
BACKUP_TARGET_PATH=$BACKUP_TARGET_HOST:$BACKUP_TARGET_ROOT/$BACKUP_TARGET_FOLDER
BACKUP_DIRS=("/var/log" "/var/mail" "/var/tmp" "/var/www" "/etc" "/home" "/boot")
KEYFILE='id_rsa'
LOGFILE=/var/log/backup.log

echo "**********************************************" >> $LOGFILE
echo "Starting Backup Run at "`date` >> $LOGFILE
echo "BACKUP_TARGET_HOST: $BACKUP_TARGET_HOST">> $LOGFILE
echo "BACKUP_TARGET_USERNAME: $BACKUP_TARGET_USERNAME">> $LOGFILE
echo "BACKUP_TARGET_ROOT: $BACKUP_TARGET_ROOT">> $LOGFILE
echo "BACKUP_TARGET_FOLDER: $BACKUP_TARGET_FOLDER">> $LOGFILE
echo "BACKUP_TARGET_PATH: $BACKUP_TARGET_PATH">> $LOGFILE
echo "**********************************************" >> $LOGFILE



for dir in ${BACKUP_DIRS[@]}
do
    echo "Backing up $dir to $BACKUP_TARGET_PATH as user $BACKUP_TARGET_USERNAME with keyfile $KEYFILE" >> $LOGFILE
    rsync -az --delete -e "ssh -i $KEYFILE" $dir $BACKUP_TARGET_USERNAME@$BACKUP_TARGET_PATH >> $LOGFILE
done

echo "**********************************************" >> $LOGFILE
echo "Finished Backup Run at "`date` >> $LOGFILE
echo "**********************************************" >> $LOGFILE
