#!/usr/bin/env bash

mkdir /opt/scripts
wget https://raw.githubusercontent.com/matuszeg/server-scripts-public/main/installPIA.sh
chmod +x installPIA.sh
mv installPIA.sh /opt/scripts/installPIA.sh

wget https://raw.githubusercontent.com/matuszeg/server-scripts-public/main/configurePIA.sh
chmod +x configurePIA.sh
mv configurePIA.sh /opt/scripts/configurePIA.sh
