#!/bin/bash
token=$DO_TOKEN
domain=$DO_DOMAIN
record=$DO_RECORD

CHECKIP_URL="http://ipinfo.io/ip"
APIURL="https://api.digitalocean.com/v2"

while getopts ":s:d:r:" arg; do
  case $arg in
    s) token=$OPTARG;;
    d) domain=$OPTARG;;
    r) record=$OPTARG;;
  esac
done

echo "Update $record.$domain record"

domain_url="$APIURL/domains"
records_url="$APIURL/domains/$domain/records"

external_ip=`curl $CHECKIP_URL`
authorization="Authorization: Bearer ${token}"
do_domain=`curl --header "$authorization" $domain_url | jq -c ".domains[] | select(.name == \"$domain\")"`
do_record=`curl --header "$authorization" $records_url | jq -c ".domain_records[] | select(.name == \"$record\")"`
ip_record=`echo $do_record | jq -c -r ".data"`

if [ "$ip_record" == "$external_ip" ]
then
    echo "Record $record.$domain already set to $external_ip"
else
    curl -H "$authorization" -H "Content-Type: application/json" --data "{\"data\":\"$external_ip\"}" -X "PUT" $records_url/`echo $do_record | jq -j '.id'`
fi

