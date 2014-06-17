debian_netconsole
=================

Scripts for convenient enabling netconsole kernel ability on Debian Squeeze, Wheezy and later (not tested yet)

Features:

Autoconfigure mac address in routed network (you can use gateway address mac automatically or set destination server mac address manually)
Script is very simple to configure 

Thoroughly tested on:
- Debian 6 Squeeze
- Debian 7 Wheezy
- Ubuntu 12.04

Fast install:
```bash
curl -k https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/install.sh | bash
```

Install guide for init.d script (RECOMMENDED):
```bash
apt-get install -y arping
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -O/etc/default/netconsole
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole -O/etc/init.d/netconsole
chmod +x /etc/init.d/netconsole
```

Install guide for network script (WARNING! NOT RECOMMENDED WAY):
```bash
apt-get install -y arping
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_network_script -O/etc/network/if-up.d/netconsole
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -O/etc/default/netconsole
chmod +x /etc/network/if-up.d/netconsole
```

Now you need to configure the script:
```bash
nano /etc/default/netconsole
#You need enable script autoload on startup:
ENABLE_NETCONSOLE="yes"
# Also you need set DESTINATION_SERVER_IP
```

Add to start on boot and start netconsole now:
```bash
# For Debian 6, 7 +
insserv netconsole
# For Ubuntu 12.04
update-rc.d netconsole defaults
/etc/init.d/netconsole start
```

Test connection on the client side:
```bash
echo "Test" > /dev/kmsg 
```

On the server side:
```bash
tcpdump -A 'port 614' 
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on venet0, link-type LINUX_SLL (Linux cooked), capture size 65535 bytes
12:13:52.485930 IP XXXX.6666 > fastvps.ee.614: UDP, length 21
E..1....:...X.....'..
.f..iD[275629.843870] Test
```
