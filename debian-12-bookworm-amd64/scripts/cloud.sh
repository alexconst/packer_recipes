#!/bin/bash -eux



case "$PACKER_BUILDER_TYPE" in

    "amazon-ebs")
        echo "$PACKER_BUILDER_TYPE provider..."
        echo "Removing any leftover SSH keys."
        echo "" > /root/.ssh/authorized_keys
        echo "" > /home/*/.ssh/authorized_keys
        ;;

    *)
        echo "Nothing to do here. Not a cloud builder."
        ;;

esac


