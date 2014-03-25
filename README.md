debian_netconsole
=================

Scripts for convient enabling netconsole kernel ability on Debian Squeeze, Wheezy and later (not tested yet)

Features:

Autoconfigure mac address in routed network (automatically use gateway address mac or you can manually set destination server mac address)
Script is very simple to configure 

Thoroughly tested on:
- Debian 6 Squeeze
- Debian 7 Wheezy

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

Install guide for network script (NOT RECOMMENDED):
```bash
apt-get install -y arping
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_network_script -O/etc/network/if-up.d/netconsole
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -O/etc/default/netconsole
chmod +x /etc/network/if-up.d/netconsole
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
