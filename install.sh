#!/bin/bash

echo "Install arping"
apt-get install -y arping

echo "Download config"
curl -k https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -o /etc/default/netconsole
echo "Download init script"
curl -k https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole -o /etc/init.d/netconsole

chmod +x /etc/init.d/netconsole

echo "Starting netconsole..."
insserv netconsole
/etc/init.d/netconsole start
