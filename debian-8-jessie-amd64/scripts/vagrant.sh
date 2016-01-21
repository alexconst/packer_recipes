#!/bin/bash -eux


# Timestamp the box
date '+%F %T' > /etc/issue.vagrant


# Create the vagrant user:group if it doesn't exit
if [[ ! -d "/home/vagrant" ]]; then
    /usr/sbin/groupadd vagrant
    /usr/sbin/useradd -g vagrant -p $(perl -e'print crypt("vagrant", "vagrant")') -m -s /bin/bash vagrant
fi

# Add user to the sudo group
usermod -a -G sudo vagrant

# Set password-less sudo for the vagrant user (Vagrant needs it)
# (setting permissions before moving file to sudoers.d)
echo '%vagrant ALL=NOPASSWD:ALL' > /tmp/vagrant
chmod 0440 /tmp/vagrant
mv /tmp/vagrant /etc/sudoers.d/


# Install public available vagrant SSH keys
# NOTE: this isn't really needed since when there is no SSH keypair, Vagrant
# will generate one. Unless you would want to disable password login from the
# start.
#mkdir /home/vagrant/.ssh
#chmod 0700 /home/vagrant/.ssh
#curl -Lo /home/vagrant/.ssh/authorized_keys 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
#chmod 0600 /home/vagrant/.ssh/authorized_keys
#chown -R vagrant:vagrant /home/vagrant/.ssh


# Install NFS (in case it's used over VirtualBox folders)
apt-get -y install nfs-common

