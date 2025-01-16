#!/bin/bash

set -xe

# stop lxc-iptag
systemctl stop lxc-iptag.service
systemctl disable lxc-iptag.service

# clean ip tags
is_valid_ipv4() {
    local ip=$1
    local regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

    if [[ $ip =~ $regex ]]; then
        IFS='.' read -r -a parts <<< "$ip"
        for part in "${parts[@]}"; do
            if ! [[ $part =~ ^[0-9]+$ ]] || ((part < 0 || part > 255)); then
                return 1
            fi
        done
        return 0
    else
        return 1
    fi
}
vmid_list=$(pct list 2>/dev/null | grep -v VMID | awk '{print $1}')
for vmid in ${vmid_list}; do
    next_tags=()

    # Parse current tags
    mapfile -t current_tags < <(pct config "${vmid}" | grep tags | awk '{print $2}' | sed 's/;/\n/g')
    for current_tag in "${current_tags[@]}"; do
        if ! is_valid_ipv4 "${current_tag}"; then
            next_tags+=("${current_tag}")
        fi
    done

    # Set tags
    echo "Setting ${vmid} tags from ${current_tags[*]} to ${next_tags[*]}"
    pct set "${vmid}" -tags "$(IFS=';'; echo "${next_tags[*]}")"
done

# remove lxc-iptag
rm -f /lib/systemd/system/lxc-iptag.service
rm -f /usr/local/etc/lxc-iptag.conf
rm -f /usr/local/bin/lxc-iptag
