#!/bin/bash

curl -sL https://github.com/gitsang/lxc-iptag/releases/download/v1.0.0/lxc-iptag -o /usr/local/bin/lxc-iptag
cp lxc-iptag         /usr/local/bin
cp lxc-iptag.service /lib/systemd/system/
