# About

Packer recipes for the following targets:
- Debian 8 (Jessie): AWS EBS, QEMU, VirtualBox-iso, VMware-iso
- Debian 11 (Bullseye): QEMU

Packer tutorial can be found at https://alexconst.github.io/2016/01/11/packer/
While it has been updated, note that the tutorial may be behind the version at the master branch.


# How To
Note that for Debian 8 you may have to adapt these instructions since the recipe hasn't been updated to be so flexible (eg: you should stick with the default vagrant user).

In order for you to access the box via ssh (and Vagrant) a user named `vagrant` with password `vagrant` is created. If you wish to change the username and pass:
```bash
read PACKER_SSH_USER
read -s PACKER_SSH_PASS
```
FYI, additional user configuration is done via the `scripts/user.sh` which is generated/updated when you `source packer_variables.sh`

Example for Debian 11:
```bash
cd debian-11-bullseye-amd64
source packer_variables.sh
export packer_template="debian-11-bullseye-amd64.json"
#export packer_template="debian-11-bullseye-amd64-i3.json"
export packer_builder_selected="bullseye-qemu"
packer validate "$packer_template"
packer inspect "$packer_template"

export PACKER_LOG=1
export PACKER_LOG_PATH="/tmp/packer_${packer_builder_selected}.log"
packer build -only="$packer_builder_selected" "$packer_template"
# if using qemu, to see the qemu command used:
cat $PACKER_LOG_PATH | grep 'qemu-system-x86_64'
# to save the log file
tmp=$(echo "${packer_template%.*}" | sed 's|\(.*-\).*\(-.*-.*\)|\1*\2|g')
tmp=`eval echo "builds.ignore/${tmp}_${packer_builder_selected}"`
mv $PACKER_LOG_PATH  $tmp/
```

