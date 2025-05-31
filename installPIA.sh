#!/usr/bin/env bash

apt update  < "/dev/null"

apt install -y wireguard
apt install -y wireguard-tools

useradd -m pia
passwd pia
usermod -aG sudo pia

su - pia --session-command='
wget https://installers.privateinternetaccess.com/download/pia-linux-3.5.7-08120.run
sh pia-linux-3.5.7-08120.run
'

wget https://raw.githubusercontent.com/matuszeg/server-scripts-public/main/piavpn.service
mv piavpn.service /etc/systemd/system/piavpn.service
chmod 755 /etc/systemd/system/piavpn.service

wget https://raw.githubusercontent.com/matuszeg/server-scripts-public/main/connectPIA.sh
mv connectPIA.sh /home/pia/connectPIA.sh
chmod +x /home/pia/connectPIA.sh

systemctl enable piavpn
systemctl start piavpn

echo "!!!!****!!!! Add the following lines to /etc/pve/lxc/<id>.conf on proxmox host and then stop/start the LXC !!!!****!!!!
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net dev/net none bind,create=dir
"
