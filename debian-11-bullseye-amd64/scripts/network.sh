#!/bin/bash -eux

################################
# CLEANUP
# Prevent network issues when cloning the image (by forcing a refresh of /etc/network/interfaces)
################################
rm -rf /etc/udev/rules.d/70-persistent-net.rules

for folder in "/var/lib/NetworkManager/" "/var/lib/dhclient/" "/var/lib/dhcp/"; do
    if [ -d "$folder" ]; then
        find "$folder" -name "*.lease" -or -name "*.leases"
        find "$folder" -name "*.lease" -or -name "*.leases" -exec rm --force {} \;
    fi
done

rm -f /etc/network/interfaces

#sed -i -e '/^auto/d' /etc/network/interfaces
#sed -i -e '/^iface/d' /etc/network/interfaces
#sed -i -e '/^allow-hotplug/d' /etc/network/interfaces
#sed -i 's/en[[:alnum:]]*/eth0/g' /etc/network/interfaces



## Work around network device naming mismatch caused by Packer & Libvirt
## TODO: figure out a better way to fix this
#cat <<'OEOF' >> /etc/rc.local
##!/bin/bash
#
##newif=$(dmesg | grep -i virtio_net | grep renamed | awk '{print $5}' | tr -d ':')
#newif=$(ls -1 /sys/class/net/ | grep -v lo | head -n 1)
#cat <<EOF > /etc/network/interfaces
## This file is being generated at boot in order to workaround an issue related to Packer and Libvirt
#
#source /etc/network/interfaces.d/*
#
## The loopback network interface
#auto lo
#iface lo inet loopback
#
## The primary network interface
##allow-hotplug $newif
#auto $newif
#iface $newif inet dhcp
#pre-up sleep 2
#EOF
#OEOF
#chmod +x /etc/rc.local

## Ensures the network interface gets an IP (in theory this shouldn't be necessary but it actually fixes an issues I'm encountering)
#apt-get install -y ifplugd
#sed -i -e 's/INTERFACES=.*/INTERFACES="all"/g' /etc/default/ifplugd
#systemctl enable ifplugd.service




################################
# CONFIG
################################

cat <<EOF > /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
EOF

# Let network-manager handle bringing network interfaces up automatically without having to tweak /etc/network/interfaces or installing anything
apt-get install -y --no-install-recommends network-manager

# Ensure the networking interfaces get configured on boot
systemctl enable networking.service

# Tweak sshd to prevent DNS resolution (speed up logins)
echo 'UseDNS no' >> /etc/ssh/sshd_config

# Disable Predictable Network Interface names (force use of eth* instead of en*)
sed -i 's/GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0 \1"/g' /etc/default/grub
update-grub


