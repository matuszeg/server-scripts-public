#!/usr/bin/env bash

echo "Enter PIA Username:"
read username
echo "Enter PIA Password:"
read password
echo "$username" >> /home/pia/login.txt
echo "$password" >> /home/pia/login.txt

piactl login /home/pia/login.txt

piactl set protocol wireguard
piactl background enable
piactl set allowlan true
piactl set requestportforward true
piactl -u applysettings '{"killswitch":"on"}'

echo "net.ipv4.ip_forward=1" | sudo -S tee -a /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6=1" | sudo -S tee -a /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6=1" | sudo -S tee -a /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6=1" | sudo -S tee -a /etc/sysctl.conf

crontab -l | grep -q 'piactl connect'  && echo 'piactl connect entry already exists' || (crontab -l 2>/dev/null; echo "@reboot /usr/local/bin/piactl connect") | crontab -
crontab -l | grep -q '/usr/sbin/iptables -A FORWARD -i eth0 -o wg0 -j ACCEPT' && echo 'iptable first accept entry already exists' || (crontab -l 2>/dev/null; echo "@reboot /usr/sbin/iptables -A FORWARD -i eth0 -o wg0 -j ACCEPT") | crontab -
crontab -l | grep -q '/usr/sbin/iptables -A FORWARD -i wgpia0 -o eth0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT' && echo 'iptable second accept entry already exists' || (crontab -l 2>/dev/null; echo "@reboot /usr/sbin/iptables -A FORWARD -i wgpia0 -o eth0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT") | crontab -
crontab -l | grep -q '@reboot /usr/sbin/iptables -t nat -A POSTROUTING -o wgpia0 -j MASQUERADE' && echo 'iptables MASQUERADE entry already exists' || (crontab -l 2>/dev/null;echo "@reboot /usr/sbin/iptables -t nat -A POSTROUTING -o wgpia0 -j MASQUERADE") | crontab -

systemctl restart piavpn
