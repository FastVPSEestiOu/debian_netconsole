#!/bin/bash

echo "Install arping"
apt-get install -y arping

echo "Download config"
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -O/etc/default/netconsole
echo "Download init script"
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole -O/etc/init.d/netconsole

chmod +x /etc/init.d/netconsole

echo "Starting netconsole..."
insserv netconsole
/etc/init.d/netconsole start
