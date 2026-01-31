#!/bin/bash

set -euo pipefail

if [ $UID -ne 0 ]; then 
    echo "Please run 'su' and then execute this script"
    exit 1
fi

echo "Listing devices ..."
fdisk -l
echo "Provide device ..."
read -p "Provide X for destination drive (/dev/sdX): " sdx
drive="/dev/sd$sdx"
# Source - https://stackoverflow.com/a/18546416
# Posted by konsolebox, modified by community. See post 'Timeline' for change history
# Retrieved 2026-01-31, License - CC BY-SA 4.0
read -p "Continue with drive $drive? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

echo "Partition device"
echo "g - Create partition table"
echo "n - Create new partition, set last sector to +1G"
echo "n - Create new partition, leave everything as default"
echo "w - Write & Exit"

fdisk "$drive"

echo "Formatting ..."
mkfs.fat -F 32 "${drive}1"
mkfs.ext4 "${drive}2"

fdisk -l "$drive"
read -p "Continue? (Y/N)" confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

echo "Mounting partitions ..."
mount "${drive}2" /mnt
mount --mkdir "${drive}1" /mnt/boot

echo "Installing requirements ..."
pacstrap -c -K /mnt base linux linux-firmware intel-ucode openssh vim sudo fastfetch

echo "Generating fstab ..."
genfstab -U /mnt >> /mnt/etc/fstab

read -p "Provide hostname: " hostname
echo "$hostname" > /mnt/etc/hostname
    
echo "Copying installer into chroot"
cp chroot-install.sh /mnt/chroot-install.sh

echo "$drive" > /mnt/drive-var 

echo "Entering chroot ..."
arch-chroot /mnt /chroot-install.sh

echo "Cleaning up ..."
rm /mnt/chroot-install.sh
rm /mnt/drive-var

echo "Syncing ..."
sync

echo "Unmounting ..."
umount -l /mnt/boot
umount -l /mnt

echo "All set. Enjoy Arch!"
