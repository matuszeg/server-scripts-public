#!/usr/bin/env bash

if test -f /home/pia/login.txt; then
  piactl background enable
  piactl -u applysettings '{"killswitch":"on"}'
  piactl set protocol wireguard --debug
  piactl set allowlan true --debug
  piactl set requestportforward true --debug
  piactl connect
fi
