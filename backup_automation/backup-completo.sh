#!/usr/bin/env sh

# Diretorio de backup

backup_path="/home/CEREBRO/sre-homelab"

# Ditetorio para aonde o backup vai.
external_storage="/mnt/backup"

# Formato do arquivo
date_format=$(date "+%d-%m-%Y")
final_archive="backup-$date_format.tar.gz"

# Aonde o log será armazenado?
log_file="/var/log/daily-backup.log"

####################################
# TESTES
####################################
# Checando se o dispositivo de backup está plugado na máquina
if ! mountpoint -q -- $external_storage; then
	printf "[$date_format] DEVICE NOT MOUNTED in: $external_storage CHECK IT.\n" >> $log_file
	exit 1
fi

####################################
# Inicio do backup.
####################################
if tar -czSpf "$external_storage/$final_archive" "$backup_path" then
	printf "[$date_format] BACKUP SUCESS.\n" >>$log_file
else
	printf "[$date_format] BACKUP ERROR.\n" >>$log_file
fi

# Exclua os aquivos que tiverem mais de X dias.
find $external_storage -mtime +10 -delete
