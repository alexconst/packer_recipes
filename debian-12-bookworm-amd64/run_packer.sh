###############################
# FREQUENTLY MODIFIED VARIABLES
###############################

# Debian ISO (sha512 checksum)
export PACKER_DEBIAN_ISO_URL="$HOME/data/home/software_archive/linux_isos/debian/debian-firmware-testing-amd64-netinst.iso" # weekly build dated 2023-01-16
export PACKER_DEBIAN_ISO_SUM="a14d5e0dab730f25756b679115fd5935aa33031c0866c8e0ff25bf3e124744a1701029474c237e23c3dac4692eef27eaf904c5aea7cf1b7914b4120bca3e2dd5"

# Packer output folder
export PACKER_OUTPUT_FOLDER="../.ignore.builds"

# VM config
export PACKER_VM_HOSTNAME="${PACKER_VM_HOSTNAME:-bookworm}"
export PACKER_VM_DISK_SIZE="${PACKER_VM_DISK_SIZE:-40960}"
export PACKER_VM_RAM="${PACKER_VM_RAM:-1024}"

# User with SSH access to be created
PACKER_SSH_USER="${PACKER_SSH_USER:-vagrant}"
PACKER_SSH_PASS="${PACKER_SSH_PASS:-vagrant}"
export PACKER_SSH_USER
export PACKER_SSH_PASS

# box version
export VM_NAME="debian-12-bookworm-amd64"
debian_version="12"




###############################
# RUN PACKER
###############################

# generate the user.sh script from the template
cat scripts/user.sh.TEMPLATE | sed 's/PACKER_SSH_USER/'"$PACKER_SSH_USER"'/g ; s/PACKER_SSH_PASS/'"$PACKER_SSH_PASS"'/g' > scripts/user.sh
chmod +x scripts/user.sh

# set config and builder, then validate
timestamp=$(date '+%Y%m%d')
export BOX_VERSION="$debian_version.$timestamp"
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
#tmp=$(echo "${packer_template%.*}" | sed 's|\(.*-\).*\(-.*-.*\)|\1*\2|g')
#tmp=`eval echo "${PACKER_OUTPUT_FOLDER}/${tmp}_${packer_builder_selected}"`
tmp=$(readlink -f "${PACKER_OUTPUT_FOLDER}/${packer_template%.*}_${packer_builder_selected}")
mv $PACKER_LOG_PATH  $tmp/

