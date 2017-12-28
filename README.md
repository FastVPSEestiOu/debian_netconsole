# debian_netconsole

Scripts for convenient enabling netconsole kernel feature on Debian 6+, Ubuntu 12.04+ and CentOS 5+.

Features:

Autoconfigure mac address in routed network (you can use gateway address mac automatically or set destination server mac address manually)
Script is very simple to configure 

Thoroughly tested on LTS distros:
- Debian 6, 7, 8, 9
- CentOS 5, 6, 7
- Ubuntu 12.04, 14.04, 16.04

## Fast install with install.sh script
```bash
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/install.sh -O /tmp/netconsole_install.sh && bash /tmp/netconsole_install.sh && rm /tmp/netconsole_install.sh
```

## Manual install
Install guide for sysdemd.service (Debian 8+; Ubuntu 16.04+):
```bash
wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -O /etc/default/netconsole --no-check-certificate -q
wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole.service -O /etc/systemd/system/netconsole.service --no-check-certificate -q
wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole.sh -O /usr/local/bin/netconsole --no-check-certificate -q
chmod +x /usr/local/bin/netconsole
systemctl daemon-reload
systemctl enable netconsole.service
systemctl start netconsole.service
```

Install guide for init.d script (Debian 6, 7; Ubuntu 12.04, 14.04):
```bash
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -O/etc/default/netconsole
wget --no-check-certificate https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_sysv -O/etc/init.d/netconsole
chmod +x /etc/init.d/netconsole
update-rc.d netconsole defaults
/etc/init.d/netconsole start
```

Install guide for CentOS 6, 7:
```bash
sed -i -e '/^SYSLOGADDR=/d' -e 's|\(# SYSLOGADDR=.*$\)|# SYSLOGADDR=\nSYSLOGADDR=148.251.39.245|g' /etc/sysconfig/netconsole
sed -i -e '/^SYSLOGPORT=/d' -e 's|\(# SYSLOGPORT=.*$\)|\1\nSYSLOGPORT=614|g' /etc/sysconfig/netconsole
chkconfig netconsole on
service netconsole start
```

*NOTE*: You will need to change DESTINATION_SERVER_IP in */etc/default/netconsole*, if you are using other monitoring server.



## Test connection
On the client side:
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
.f..iD[275629.843870] fastvps_test
```
