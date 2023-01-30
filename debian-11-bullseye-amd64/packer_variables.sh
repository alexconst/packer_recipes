# Debian ISO (sha512 checksum)
export PACKER_DEBIAN_ISO_URL="$HOME/data/home/software_archive/linux_isos/debian/debian-firmware-11.6.0-amd64-netinst.iso"
export PACKER_DEBIAN_ISO_SUM="33bf983fb389bb72f9a20584c04f55d393cb0b048ba1a150190c8756d7259ac0ac7438b54635a39daecdf4d5fe18ebe7620272ac708f3003ed257194a79f8260"

# VM config
export PACKER_VM_HOSTNAME="${PACKER_VM_HOSTNAME:-bullseye}"
export PACKER_VM_DISK_SIZE="${PACKER_VM_DISK_SIZE:-5120}"
export PACKER_VM_RAM="${PACKER_VM_RAM:-1024}"


# User with SSH access to be created
PACKER_SSH_USER="${PACKER_SSH_USER:-vagrant}"
PACKER_SSH_PASS="${PACKER_SSH_PASS:-vagrant}"
export PACKER_SSH_USER
export PACKER_SSH_PASS

# generate the user.sh script
cat scripts/user.sh.TEMPLATE | sed 's/vagrant/'"$PACKER_SSH_USER"'/g ; s/PACKER_SSH_PASS/'"$PACKER_SSH_PASS"'/g' > scripts/user.sh
chmod +x scripts/user.sh

# VirtualBox additions ISO (sha256 checksum)
#export PACKER_VBOX_ISO_URL="/usr/share/virtualbox/VBoxGuestAdditions.iso"
#export PACKER_VBOX_ISO_SUM="e5b425ec4f6a62523855c3cbd3975d17f962f27df093d403eab27c0e7f71464a"

# AWS credentials
# not declared here because they're sourced from AWS config files

