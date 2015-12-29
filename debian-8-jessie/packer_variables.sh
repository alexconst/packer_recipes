# Debian Jessie ISO (sha512 checksum)
export PACKER_DEBIAN_ISO_URL="$HOME/home/software_archive/linux_isos/debian/debian-8.2.0-amd64-netinst.iso"
#export PACKER_DEBIAN_ISO_URL="http://cdimage.debian.org/debian-cd/8.2.0/amd64/iso-cd/debian-8.2.0-amd64-netinst.iso"
export PACKER_DEBIAN_ISO_SUM="923cd1bfbfa62d78aecaa92d919ee54a95c8fca834b427502847228cf06155e7243875f59279b0bf6bfd1b579cbe2f1bc80528a265dafddee9a9d2a197ef3806"

# User to be created
export PACKER_SSH_USER="vagrant"
export PACKER_SSH_PASS="vagrant"

# VirtualBox additions ISO (sha256 checksum)
export PACKER_VBOX_ISO_URL="/usr/share/virtualbox/VBoxGuestAdditions.iso"
export PACKER_VBOX_ISO_SUM="e5b425ec4f6a62523855c3cbd3975d17f962f27df093d403eab27c0e7f71464a"

# AWS credentials
# not declared here because they're sourced from AWS config files

