debian_netconsole
=================

Scripts for convient enabling netconsole kernel ability on Debian Squeeze, Wheezy and later (not tested yet)

Features:

Autoconfigure mac address in routed network (automatically use gateway address mac or you can manually set destination server mac address)
Script is very simple to configure 

Thoroughly tested on:
- Debian 6 Squeeze
- Debian 7 Wheezy

Install guide for init.d script (NOT RECOMMENDED):
```bash
apt-get install -y arping
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -O/etc/default/netconsole
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole -O/etc/init.d/netconsole
chmod +x /etc/init.d/netconsole
```

Install guide for network script (RECOMMENDED):
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

Why /etc/init.d/netconsole is WORST place for netconsole?
```bash
[    5.839211] md: delaying resync of md3 until md2 has finished (they share one or more physical units)
[    5.839214] md: delaying resync of md1 until md2 has finished (they share one or more physical units)
[    5.926499] EXT4-fs (md3): mounted filesystem with ordered data mode
[    6.177903] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    6.574141] Netconsole script started
[    9.534781] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[    9.536649] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   12.072795] netconsole: local port 6666
[   12.072866] netconsole: local IP 88.198.xx.xx
[   12.072936] netconsole: interface eth0
[   12.073000] netconsole: remote port 614
[   12.073062] netconsole: remote IP 148.251.xx.xx
[   12.073126] netconsole: remote ethernet address 78:aa:aa:bb:aa:aa
[   12.092371] console [netcon0] enabled
[   12.092438] netconsole: network logging started
[   20.467394] eth0: no IPv6 routers present
```
