#!/bin/bash -eux

# Set up dynamic MOTD as in ubuntu and described at
# https://oitibs.com/debian-jessie-dynamic-motd/
# TODO: check the module for existing software updates at
# https://nickcharlton.net/posts/debian-ubuntu-dynamic-motd.html

# scripts modified to also:
# - show available RAM
# - show available disk
# - print vagrant issue file if it exists


echo "Installing scripts for dynamic MOTD..."

# install figlet to enable ASCII art
apt-get install -y figlet
# create directory
mkdir -p /etc/update-motd.d/



# MOTD header
cat <<'EOF' > /etc/update-motd.d/00-header
#!/bin/sh
#
#    00-header - create the header of the MOTD
#    Copyright (c) 2013 Nick Charlton
#    Copyright (c) 2009-2010 Canonical Ltd.
#
#    Authors: Nick Charlton <hello@nickcharlton.net>
#             Dustin Kirkland <kirkland@canonical.com>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

[ -r /etc/lsb-release ] && . /etc/lsb-release

if [ -z "$DISTRIB_DESCRIPTION" ] && [ -x /usr/bin/lsb_release ]; then
        # Fall back to using the very slow lsb_release utility
        DISTRIB_DESCRIPTION=$(lsb_release -s -d)
fi
issue_file="/etc/issue.net"
if [ -z "$DISTRIB_DESCRIPTION" ] && [ -e "$issue_file" ]; then
    DISTRIB_DESCRIPTION=`cat $issue_file`
fi

figlet $(hostname)
printf "\n"

printf "Welcome to %s (%s)\n" "$DISTRIB_DESCRIPTION" "$(uname -r)"
if [ -e /etc/issue.vagrant ]; then
    timestamp=`cat /etc/issue.vagrant`
    printf "Vagrant box creation date: %s\n" "$timestamp"
fi
printf "\n"
EOF



# MOTD sysinfo
cat <<'EOF' > /etc/update-motd.d/10-sysinfo
#!/bin/bash
#
#    10-sysinfo - generate the system information
#    Copyright (c) 2013 Nick Charlton
#
#    Authors: Nick Charlton <hello@nickcharlton.net>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

date=`date`
load=`cat /proc/loadavg | awk '{print $1}'`
root_usage=`df -h / | awk '/\// {percent=$(NF-1); avail=$(NF-2); print percent " (" avail " free)"}'`
memory_usage=`free -m | awk '/Mem:/ { total=$2 } /buffers\/cache/ { used=$3 } END { printf("%3.1f%% (%0.2fG avail)", used/total*100, (total-used)/1000)}'`
swap_usage=`free -m | awk '/Swap/ { printf("%3.1f%%", "exit !$2;$3/$2*100") }'`
users=`users | wc -w`
time=`uptime | grep -ohe 'up .*' | sed 's/,/\ hours/g' | awk '{ printf $2" "$3 }'`
processes=`ps aux | wc -l`
ip=`ifconfig $(route | grep default | awk '{ print $8 }') | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`

echo "System information as of: $date"
echo
printf "System load:\t%s\t\t\tIP Address:\t%s\n" $load $ip
printf "Memory usage:\t%s\tSystem uptime:\t%s\n" "$memory_usage" "$time"
printf "Usage on /:\t%s\t\tSwap usage:\t%s\n" "$root_usage" "$swap_usage"
printf "Local Users:\t%s\t\t\tProcesses:\t%s\n" "$users" "$processes"
echo

EOF



# MOTD footer
cat <<'EOF' > /etc/update-motd.d/90-footer
#!/bin/sh
#
#    90-footer - write the admin's footer to the MOTD
#    Copyright (c) 2013 Nick Charlton
#    Copyright (c) 2009-2010 Canonical Ltd.
#
#    Authors: Nick Charlton <hello@nickcharlton.net>
#             Dustin Kirkland <kirkland@canonical.com>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

[ -f /etc/motd.tail ] && cat /etc/motd.tail || true

EOF



# make files executable
chmod +x /etc/update-motd.d/*
# remove MOTD file
rm /etc/motd
# symlink dynamic MOTD file
ln -s /var/run/motd /etc/motd

