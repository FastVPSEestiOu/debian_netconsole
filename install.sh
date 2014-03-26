#!/bin/bash

apt-get update > /dev/null

echo "Install arping"
apt-get install -y arping

echo "Download config"
curl -k https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -o /etc/default/netconsole
echo "Download init script"
curl -k https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole -o /etc/init.d/netconsole

chmod +x /etc/init.d/netconsole

echo "Starting netconsole..."

if [ -e "/sbin/insserv" ]; then
    insserv netconsole
else
    # Probably it's Ubuntu 12.04 without insserv
    if [ -e "/usr/sbin/update-rc.d" ]; then 
        update-rc.d netconsole defaults
    fi
fi


/etc/init.d/netconsole start
