# lxc-iptag

lxc-iptag is a simple script to add ip tags to LXC containers.

![](./img/pve-lxc-iptag.png)

This script is only a transitional solution for the official UI to support displaying IPs of LXC containers. See [Displaying IP of container in GUI?](https://forum.proxmox.com/threads/displaying-ip-of-container-in-gui.120841/#post-685752)

> My original intention was to provide a script that is simple enough and easy to review, avoiding introducing too much complexity as much as possible. After all, this script may be replaced by official support in the near future, and shell scripts and tags are certainly not the best solution. Therefore, this script may not consider introducing too much complex logic or requirements.
>
> Simple scripts allow users to easily modify the script according to their needs with just a little knowledge of Shell scripting. So feel free to fork it. And to save your time, https://github.com/MorsStefan/proxmox-ip2tag is a cool project that supports more features, especially adding iptag support for VMs. You can first check if this project meets your needs.

## 1. Installation

```sh
curl -sL https://github.com/gitsang/lxc-iptag/raw/main/install.sh | bash
```

This script will:

- Install script prerequisites
- Install the `lxc-iptag` script to `/usr/local/bin/lxc-iptag`
- Copy config file to `/usr/local/etc/lxc-iptag.conf`
- Add a systemd unit to start the service

### 1.1 Update

```sh
curl -sSL https://raw.githubusercontent.com/gitsang/lxc-iptag/main/lxc-iptag -o /usr/local/bin/lxc-iptag && chmod +x /usr/local/bin/lxc-iptag
systemctl restart lxc-iptag.service
```

This script will only update the `lxc-iptag` executable script

## 2. Configure

Open `/usr/local/etc/lxc-iptag.conf` and change the config

| Option                          | Example                                     | Description                                                                                             |
| ------------------------------- | ------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| CIDR_LIST                       | `(192.168.0.0/16 172.16.0.0/12 10.0.0.0/8)` | IP filter list in CIDR format                                                                           |
| LOOP_INTERVAL                   | `60`                                        | Main loop interval(seconds)                                                                             |
| FW_NET_INTERFACE_CHECK_INTERVAL | `60`                                        | The interval(seconds) for using `ip link` to check lxc status changed (Set -1 to disable this feature) |
| LXC_STATUS_CHECK_INTERVAL       | `-1`                                        | The interval(seconds) for using `pct list` to check lxc status changed (Set -1 to disable this feature) |
| FORCE_UPDATE_INTERVAL           | `1800`                                      | The interval(seconds) for force check and update lxc tags                                               |
| EXCLUSION_LIST                  | see [lxc-iptag.conf](./lxc-iptag.conf)      | List of container id or ip to exclude from tagging                                                         |

## 3. Uninstall

```sh
# stop lxc-iptag
systemctl stop lxc-iptag.service
systemctl disable lxc-iptag.service

# remove lxc-iptag
rm -f /lib/systemd/system/lxc-iptag.service
rm -f /usr/local/etc/lxc-iptag.conf
rm -f /usr/local/bin/lxc-iptag
```

If you want to remove all lxc-iptag related datas (includes all ip tags), run the following command:

This script will:

- Stop and disable `lxc-iptag` systemd service
- Remove pve all lxc ip tags
- Delete all lxc-iptag related systemd unit, config file and script

```sh
curl -sL https://github.com/gitsang/lxc-iptag/raw/main/uninstall.sh | bash
```
