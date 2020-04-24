# do_updater
Simple script to dyndns with digitalocean

# Usage
`bash updater.sh -sDIGITALOCEAN_SECRET -dDIGITALOCEAN_DOMAIN -rNEW_RECORD`

## To keep it updated add it to the crontab
```
secret=***************
domain=***************
record=***************
script_path="/home/user/**/updater.sh"

read -r -d '' cronjob << EOM
$(crontab -l)
0 5 * * *  /home/pi/.local/bin/updater.sh -s$secret -d$domain -r$record
EOM
echo "$cronjob" | crontab -
```
