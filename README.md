# About

Packer recipes for the following targets:
- Debian 8 (Jessie): AWS EBS, QEMU, VirtualBox-iso, VMware-iso
- Debian 11 (Bullseye): QEMU
- Debian 12 (Bookworm): QEMU

Packer tutorial can be found at https://alexconst.github.io/2016/01/11/packer/
While it has been updated, note that the tutorial may be behind the version at the master branch.


# Troubleshooting

## errors during installer

I've used Packer maybe a dozen times for Debian 11 and it worked flawlessly. But when trying to install Debian 12 with basically the same configuration what happened was that the first two times I got strange random errors: one related to an invalid preseed web server and the other to a mismatched password. What they have in common is that they're both related to unreliable character typing/transmission right after the installer menu shows up. On the third time things went fine.
Anyway, the tldr is simply try again, and better not type or mouse move during that phase.

