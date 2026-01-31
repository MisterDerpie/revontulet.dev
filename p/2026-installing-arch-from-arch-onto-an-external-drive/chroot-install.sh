#!/bin/bash

set -euo pipefail

echo "Setting up root user - Provide a password"
passwd

echo "Setting time and locale to Helsinki and en_UTF8"
ln -sf /usr/share/zoneinfo/Europe/Helsinki /etc/localtime

hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

bootctl install

echo "Creating Loader Config and Entry /boot/loader/loader.conf and /boot/loader/entries/arch.conf"
cat > /boot/loader/loader.conf<< EOF
default arch
timeout 5
EOF

drive=$(cat /drive-var)
partuuid=$(blkid -s PARTUUID -o value ${drive}2)

cat > /boot/loader/entries/arch.conf<< EOF
title  Arch Linux
linux  /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID=$partuuid rw
EOF

echo "Example for IP config: 192.168.8.100/24 with Gateway 192.168.8.1 and DNS 9.9.9.9 and 8.8.8.8"

read -p "Provide IPv4 Address: " ipaddrr
read -p "Provide IPv4 CIDR: " ipcidr
read -p "Provide IPv4 Gateway: " ipgw
read -p "Provide IPv4 1st DNS: " dnsone
read -p "Provide IPv4 2nd DNS: " dnstwo

cat > /etc/systemd/network/20-wired.network<< EOF
[Match]
Kind=!*
Type=ether

[Network]
Address=${ipaddrr}/${ipcidr}
Gateway=$ipgw
DNS=$dnsone
DNS=$dnstwo
EOF

echo "Configuration created:"
cat /etc/systemd/network/20-wired.network
read -p "Does this look correct? (Y/N) " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable sshd.service

read -p "Provide username: " username
useradd -m $username
echo "Create password for $username"
passwd $username
