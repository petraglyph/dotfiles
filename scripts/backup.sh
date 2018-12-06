#/bin/sh
# Backup
# $ sudo cp ~/.i3/scripts/backup.sh /etc/cron.weekly/backup
# $ sudo chmod +x /etc/cron.weekly/backup

# rsync -a --delete --quiet /folder/to/backup /location/of/backup

sudo rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/swapfile","/home/*"} / /home/penn/Storage/Backups/root/
#sudo rsync -aAXv --exclude={'/home/*/.atom/*', '/Android/*', '/Applications/*', '/Desktop/*', '/Documents/*', '/Downloads/*', '/Dropbox/*', '/Music/*', '/pCloudDrive/*', '/Pictures/*', '/Public/*', '/Storage/*', '/Templates/*', '/Videos/*', '/.cache/*', '/.local/share/Steam/*'} /home/penn/ /home/penn/Storage/Backups/home/
rsync -a --delete --quiet /home/penn/.config/ /home/penn/Storage/Backups/config
