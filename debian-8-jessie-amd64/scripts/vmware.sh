#!/bin/bash -eux

# https://github.com/vmware/open-vm-tools
# https://github.com/vmware/open-vm-tools#will-the-commercial-version-vmware-tools-differ-from-the-open-source-version-open-vm-tools-if-so-how
#   Will the commercial version (VMware Tools) differ from the open source version (open-vm-tools)? If so, how?
#   However, we do currently make use of certain components licensed from third parties as well as components from other VMware products which are only available in binary form.
# An advantage on using the open-vm-tools is that they are updated, while an older VMware version of the tools will not.
# NOTE: for some (bug?) reason higher resolution in console mode does not work. The workaround is to SSH to the machine.
# NOTE: installing open-vm-tools-desktop is required if you want the guest VM to support a higher resolution or screen autofit. Do it manually or adapt this script.

use_open_vm_tools=1


install_headers () {
    apt-get install -y linux-headers-$(uname -r) build-essential perl
    apt-get install -y dkms
}

clean_headers () {
    apt-get -y remove linux-headers-$(uname -r) build-essential perl
    apt-get -y autoremove
}

case "$PACKER_BUILDER_TYPE" in

    "vmware-iso" | "vmware-ovf")
        echo "Installing VMware Tools guest additions"
        if [ $use_open_vm_tools -eq 0 ]; then
            install_headers
            iso_url="/var/tmp/linux.iso"
            mkdir -p /mnt/cdrom
            mount -o loop "$iso_url" /mnt/cdrom
            mkdir -p /tmp/vmtools/
            tar -zxvf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/vmtools
            /tmp/vmtools/vmware-tools-distrib/vmware-install.pl --default
            umount /mnt/cdrom
            rm "$iso_url"
            rm -rf /tmp/vmtools
            clean_headers
        elif [ $use_open_vm_tools -eq 1 ]; then
            install_headers
            apt-get install -y open-vm-tools open-vm-tools-dkms
            clean_headers
        else
            echo "ERROR: something went wrong. Incorrect choice of vm tools."
            exit 3
        fi
        ;;

    *)
        echo "Nothing to do here. Not a VMware builder."
        ;;

esac


