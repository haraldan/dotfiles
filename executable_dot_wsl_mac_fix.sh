#!/usr/bin/env bash
MAC="00:15:5d:ee:55:23"

# Ensure dummy0 exists with fixed MAC
# ip link add may fail with EEXIST if the dummy module auto-creates dummy0 on load
sudo ip link add dummy0 type dummy 2>/dev/null || true
if [ "$(cat /sys/class/net/dummy0/address)" != "$MAC" ]; then
    sudo ip link set dummy0 address "$MAC"
fi
