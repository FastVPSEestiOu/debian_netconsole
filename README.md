debian_netconsole
=================

Scripts for convenient enabling netconsole kernel ability on Debian Squeeze, Wheezy and later (not tested yet)

Features:

Autoconfigure mac address in routed network (you can use gateway address mac automatically or set destination server mac address manually)
Script is very simple to configure 

Thoroughly tested on:
- Debian 6, 7, 8
- Ubuntu 12.04, 14.04, 16.04

Fast install:
```bash
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/install.sh -O /tmp/netconsole_install.sh && bash /tmp/netconsole_install.sh && rm /tmp/netconsole_install.sh
```

Install guide for sysdemd.service (Debian 8; Ubuntu 16.04):
```bash
wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -O /etc/default/netconsole --no-check-certificate -q
wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole.service -O /etc/systemd/system/netconsole.service --no-check-certificate -q
wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole.sh -O /usr/local/bin/netconsole --no-check-certificate -q
chmod +x /usr/local/bin/netconsole
```

Install guide for init.d script (Debian 6, 7; Ubuntu 12.04, 14.04):
```bash
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -O/etc/default/netconsole
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_sysv -O/etc/init.d/netconsole
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
# For Debian 8 and Ubuntu 16.04
systemctl daemon-reload
systemctl enable netconsole.service
systemctl start netconsole.service
# For Debian 6, 7 and Ubuntu 12.04, 14.04
update-rc.d netconsole defaults
/etc/init.d/netconsole start
```

Test connection on the client side:
```bash
echo "fastvps_test" > /dev/kmsg 
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
