#!/bin/bash -eux

if [ $PACKER_BUILDER_TYPE == 'qemu' ]; then
    echo "Installing qemu guest additions"

    apt-get install -y qemu-guest-agent

else
    echo "Nothing to do here. Not a qemu builder."
fi


