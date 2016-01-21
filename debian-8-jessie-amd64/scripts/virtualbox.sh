#!/bin/bash -eux

# NOTE: if driver support for X11/Xorg is desired, then this script should only
# be called after the relevant packages are installed, otherwise you'll get the
# warning message: Could not find the X.Org or XFree86 Window System, skipping.

if [ $PACKER_BUILDER_TYPE == 'virtualbox-iso' ]; then
    echo "Installing VirtualBox guest additions"

    apt-get install -y linux-headers-$(uname -r) build-essential perl
    apt-get install -y dkms

    # file location not dependent on username or uid (it was not possible to copy it to /etc)
    VBOX_VERSION=$(cat /home/*/.vbox_version)
    mount -o loop /var/tmp/VBoxGuestAdditions_${VBOX_VERSION}.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run --nox11
    umount /mnt
    rm /var/tmp/VBoxGuestAdditions_${VBOX_VERSION}.iso

    apt-get -y remove linux-headers-$(uname -r) build-essential perl
    apt-get -y autoremove

else
    echo "Nothing to do here. Not a VirtualBox builder."
fi


