#!/bin/bash

apt-get update > /dev/null

echo "Install arping"
apt-get install -y arping

echo "Download config"
wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -O /etc/default/netconsole --no-check-certificate
echo "Download init script"
wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole -O /etc/init.d/netconsole --no-check-certificate

chmod +x /etc/init.d/netconsole

echo "Starting netconsole..."

if [ -e "/sbin/insserv" ]; then
    insserv netconsole
else
    # Probably it's Ubuntu 12.04, 14.04 without insserv
    if [ -e "/usr/sbin/update-rc.d" ]; then 
        update-rc.d netconsole defaults
    fi
fi

/etc/init.d/netconsole start
