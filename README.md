debian_netconsole
=================

Scripts for convient enabling netconsole kernel ability on Debian Squeeze, Wheezy and later

I'm providing open source script for managing netconsole module on Debian Squeeze for you! :)

Features:

Autoconfigure mac address in routed network (automatically use gateway address mac or you can manually set destination server mac address)
Script is very simple to configure 


You can install it manually:
```bash
apt-get install -y arping
cd /usr/src
wget https://fastvps.googlecode.com/svn/trunk/scripts/netconsole/netconsole_conf -O/etc/default/netconsole --no-check-certificate
wget https://fastvps.googlecode.com/svn/trunk/scripts/netconsole/netconsole -O/etc/init.d/netconsole --no-check-certificate
chmod +x /etc/init.d/netconsole
```

Now you need configure script:
```bash
nano /etc/default/netconsole
You need enable script autoload on startup:
ENABLE_NETCONSOLE="yes"
```

Also you need set DESTINATION_SERVER_IP.

Okay,  show must go on! Startup netconsole!
```bash
insserv netconsole
/etc/init.d/netconsole start
```
