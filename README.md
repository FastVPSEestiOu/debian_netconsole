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
wget --no-check-certificate https://raw.githubusercontent.com/vps2fast/debian_netconsole/master/netconsole_conf -O/etc/default/netconsole
wget --no-check-certificate https://raw.githubusercontent.com/vps2fast/debian_netconsole/master/netconsole -O/etc/init.d/netconsole
chmod +x /etc/init.d/netconsole
```

Now you need configure script:
```bash
nano /etc/default/netconsole
#You need enable script autoload on startup:
ENABLE_NETCONSOLE="yes"
# Also you need set DESTINATION_SERVER_IP
```

Add to start on boot and start netconsole now:
```bash
insserv netconsole
/etc/init.d/netconsole start
```

Test connection on client:
```bash
echo "Test" > /dev/kmsg 
```

On server:
```bash
tcpdump -A 'port 614' 
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on venet0, link-type LINUX_SLL (Linux cooked), capture size 65535 bytes
12:13:52.485930 IP XXXX.6666 > fastvps.ee.614: UDP, length 21
E..1....:...X.....'..
.f..iD[275629.843870] Test
```
