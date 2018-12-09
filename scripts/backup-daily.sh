#/bin/sh
# Backup Daily
# $ sudo cp ~/.i3/scripts/backup-daily.sh /etc/cron.daily/backup
# $ sudo chmod +x /etc/cron.daily/backup

# rsync -a --delete --quiet /folder/to/backup /location/of/backup

rsync -a --delete --quiet /home/penn/.config/ /home/penn/Storage/Backups/config
cp /home/penn/.bashrc /home/penn/Storage/Backups
