# db-backup

add a crontab to the line

```
#db backups
0 6,18 * * * cd /var/www/tools/db && sh db-backup-with-ftp.sh
```
