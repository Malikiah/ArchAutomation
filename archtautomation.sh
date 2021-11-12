#!/bin/bash

    bash 0-preinstall.sh
    arch-chroot /mnt /root/ArchAutomation/1-setup.sh
    source /mnt/root/ArchAutomation/install.conf
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchAutomation/2-user.sh
    arch-chroot /mnt /root/ArchAutomation/3-post-setup.sh