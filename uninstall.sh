#!/bin/bash

set -xe

# stop lxc-iptag
systemctl stop lxc-iptag.service
systemctl disable lxc-iptag.service

# remove lxc-iptag
rm -f /lib/systemd/system/lxc-iptag.service
rm -f /usr/local/etc/lxc-iptag.conf
rm -f /usr/local/bin/lxc-iptag
