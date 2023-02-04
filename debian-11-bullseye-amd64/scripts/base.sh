#!/bin/bash -eux

# Fix errors "debconf: unable to initialize frontend: Dialog", "debconf: unable to initialize frontend: Readline"
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Update the box
apt-get -y update

# Remove 5s grub timeout to speed up booting
cat <<EOF > /etc/default/grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.

GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX="debian-installer=en_US"
EOF
update-grub

# Remove ids
for filename in "/var/lib/dbus/machine-id" "/etc/machine-id" "/run/machine-id"; do
    if [ -f "$filename" ]; then
        truncate --size=0 "$filename"
    fi
done

rm -f /var/lib/systemd/random-seed

