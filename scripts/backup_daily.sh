# Script /opt/backup_daily.sh

#!/bin/bash
# Script de sauvegarde planifiée
DATE=$(date +%F)
cp -r /home/$USER/Documents/important /home/$USER/backups/daily_$DATE
echo "$(date '+%F %T') : Backup daily lancé" >> /var/log/monitor_backup.log

