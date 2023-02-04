# How To

## create a box
In order for you to access the box via ssh (and Vagrant) a user named `vagrant` with password `vagrant` is created. If you wish to change the username and pass:
```bash
read PACKER_SSH_USER
read -s PACKER_SSH_PASS
```
FYI, additional user configuration is done via the `scripts/user.sh` which is generated/updated when you `source packer_variables.sh`

Example for Debian 11:
```bash
# feel free to change variables/settings in run_packer.sh before running it
source run_packer.sh
```

## add the box to Vagrant
NOTE: be aware if you wish for the vagrant boxes to exist in a different disk you will want to relocate `~/.vagrant.d` and add `export VAGRANT_HOME=...` in your shellrc file
NOTE: also be aware that when you deploy a vm with `vagrant up` the image will be copied to whatever location your virtualization system decides (eg: /var/lib/libvirt/images/)

```bash
source run_vagrant_box_add.sh
```

