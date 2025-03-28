#!/bin/bash

set -xe

# install prerequisites
apt install -y ipcalc

# install lxc-iptag
curl -sSL https://raw.githubusercontent.com/gitsang/lxc-iptag/main/lxc-iptag -o /usr/local/bin/lxc-iptag && chmod +x /usr/local/bin/lxc-iptag
curl -sSL https://raw.githubusercontent.com/gitsang/lxc-iptag/main/lxc-iptag.conf -o /usr/local/etc/lxc-iptag.conf

# configure lxc-iptag systemd
curl -sSL https://raw.githubusercontent.com/gitsang/lxc-iptag/main/lxc-iptag.service -o /etc/systemd/system/lxc-iptag.service

# start lxc-iptag
systemctl daemon-reload
systemctl enable lxc-iptag.service
systemctl start lxc-iptag.service
