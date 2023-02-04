###############################
# FREQUENTLY MODIFIED VARIABLES
###############################

# Debian ISO (sha512 checksum)
export PACKER_DEBIAN_ISO_URL="$HOME/data/home/software_archive/linux_isos/debian/debian-firmware-11.6.0-amd64-netinst.iso"
export PACKER_DEBIAN_ISO_SUM="33bf983fb389bb72f9a20584c04f55d393cb0b048ba1a150190c8756d7259ac0ac7438b54635a39daecdf4d5fe18ebe7620272ac708f3003ed257194a79f8260"

# Packer output folder
export PACKER_OUTPUT_FOLDER="builds.ignore"

# VM config
export PACKER_VM_HOSTNAME="${PACKER_VM_HOSTNAME:-bullseye}"
export PACKER_VM_DISK_SIZE="${PACKER_VM_DISK_SIZE:-40960}"
export PACKER_VM_RAM="${PACKER_VM_RAM:-1024}"

# User with SSH access to be created
PACKER_SSH_USER="${PACKER_SSH_USER:-vagrant}"
PACKER_SSH_PASS="${PACKER_SSH_PASS:-vagrant}"
export PACKER_SSH_USER
export PACKER_SSH_PASS

# box version
debian_version="11"
timestamp=$(date '+%Y%m%d')
export BOX_VERSION="$debian_version.$timestamp"




###############################
# RUN PACKER
###############################

# generate the user.sh script from the template
cat scripts/user.sh.TEMPLATE | sed 's/PACKER_SSH_USER/'"$PACKER_SSH_USER"'/g ; s/PACKER_SSH_PASS/'"$PACKER_SSH_PASS"'/g' > scripts/user.sh
chmod +x scripts/user.sh

# set config and builder, then validate
export VM_NAME="debian-11-bullseye-amd64"
export packer_template="$VM_NAME.json"
export packer_builder_selected="libvirt"
packer validate "$packer_template"
packer inspect "$packer_template"

# build image
export PACKER_LOG=1
export PACKER_LOG_PATH="/tmp/packer_${packer_builder_selected}.log"
packer build -only="$packer_builder_selected" "$packer_template"

# print build info
echo "QEMU command used to create the image:"
cat $PACKER_LOG_PATH | grep 'qemu-system-x86_64'
# to save the log file
tmp=$(echo "${packer_template%.*}" | sed 's|\(.*-\).*\(-.*-.*\)|\1*\2|g')
tmp=`eval echo "${PACKER_OUTPUT_FOLDER}/${tmp}_${packer_builder_selected}"`
mv $PACKER_LOG_PATH  $tmp/

