---
title: Installing Arch from Arch onto an External Drive
description: >
    This post walks through how to install Arch Linux from within another Arch Linux onto an external drive.
    The result is a headless Arch to SSH into.
slug: 2026-installing-arch-from-arch-onto-an-external-drive
date: 2026-01-30 10:00:00+0000
categories:
    - Tech
tags:
    - Linux
keywords:
    - Linux
    - Arch
weight: 1
---

To install Arch Linux, the most common and easiest way is booting it up from an installation media.
This may not be an option, and instead we want to install it straight onto a drive.
The Arch Wiki provides a guide to [Install Arch Linux from existing Linux](https://wiki.archlinux.org/title/Install_Arch_Linux_from_existing_Linux), but it took a while to get all pieces right.
Consider this post to aim for a more noob-friendly and handholding setup on how to _install Arch from Arch_.
For readability, only hyperlinks not referring to [wiki.archlinux.org](wiki.archlinux.org) are marked with their source in brackets.

# Motivation

The first month of 2026 is already over, how time flies!
But that also means one thing: Time for new projects!
For starters, I needed Arch Linux as a headless distro for a computer that should become a server.
Naturally, said machine does not have any peripherals, except a LAN cable that connects it to the router.
Therefore, the need to _install Arch from Arch_ was there.
I've installed Arch plenty of times from a bootable media,
and when [archinstall](https://wiki.archlinux.org/title/Archinstall) came around that was even easier.
Yet, for the first time, I had to install and configure it non-interactive.

## Installing Arch

**Important:** 
All commands here are executed as the superuser.
Either run them with `sudo` or first run `su`, and then execute them.

Each section starts with a bullet point, referring to the page in the official Arch Wiki guide, that may be consulted for additional readup.

### Prerequesites

A host system that runs Arch, a target drive that we install Arch on, and two packages.
The first is the _arch-install-scripts_, which contains _pacstrap_.
Second is _dosfstools_, used to create FAT32 partitions.

```
pacman -Sy arch-install-scripts dosfstools
```

We're assuming that the target machine supports UEFI, not BIOS.

### Partitioning and Formatting

#### Partitioning 

* [Partition the disks](https://wiki.archlinux.org/title/Installation_guide#Partition_the_disks)

Before we're able to meaningfully interact with our drive, we need to partition it.
That is, create separated logical spaces on the underlying drive for where to place data.
Essentially, at least two partitions are required.

1. The `boot` partition, which contains information for the machine to load on start, of type `fat32`
2. The `system` partition, where the whole OS lives, of type `ext4`

For years I also used to create a [Swap](https://wiki.archlinux.org/title/Swap) partition.
It seems that nowadays Swap is really not a thing anymore.

To partition, we're using [fdisk](https://wiki.archlinux.org/title/Fdisk).

```bash
fdisk -l 
```

Search for the correct drive in the output (last mention: make sure you ran as superuser, otherwise you see access errors).

```
...
Disk /dev/sda: 931.51 GiB, 1000204886016 bytes, 1953525168 sectors
Disk model:  SN7100 1TB     
```

In my case, that is `/dev/sda`, as I can tell from the disk model.
Next, we use _fdisk_ to partiton the disk.
Replace the _X_ with the letter of your drive, in my case, that would be _a_.

```
fdisk /dev/sdX
```

For brevity, the commands we execute in order are listed in bullet points.

* `g` - Create a new GPT partition table
* `n` - Create a new partition
    * `Partition number` can be left to default (just hit _return_)
    * `First sector` can be left to default (just hit _return_)
    * `Last sector` should be set to `+1G`, which sets "Last Sector = First Sector + 1 GB"
    * In case fdisk asks about a signature, select "Yes" to remove it.

We once again create a new partition, this time leaving the last sector empty.

* `n` - Create a new partition
    * `Partition number` can be left to default (just hit "return")
    * `First sector` can be left to default (just hit "return")
    * `Last sector` **leave it empty**, the partition will then be the remaining size of the drive.

Last but not least, we need to write the partition layout onto the drive.
**Note:** This step is (more or less) irreversible, so double check you got the right drive..

* `w` - Write the created partition layout and exit fdisk.

#### Formatting

* [Format the Partitions](https://wiki.archlinux.org/title/Installation_guide#Format_the_partitions)

Partitions itself are merely a unit of space separation, and don't provide any additional information about data stored on them.
The abstraction to do so are [filesystems](https://wiki.archlinux.org/title/File_systems).
For the boot partition, that must be [FAT32](https://wiki.archlinux.org/title/FAT),
whereas for the system partition, we choose [ext4](https://wiki.archlinux.org/title/Ext4).

My drive was at `/dev/sda`, thus my boot partition now is `/dev/sda1` and the system partition is `/dev/sda2`.
Replace the `X` with the letter of your drive, in my case that would be `a`.

**Note:** In case the fat formatting command is not found, run `pacman -S dosfstools` to install it.

1. `mkfs.fat -F 32  /dev/sdX1`, creates a _FAT32_ file system on the boot partition
2. `mkfs.ext4       /dev/sdX2`, creates an _ext4_ file system on the boot partition

We can verify that this works by running `fdisk -l` again.

```
Disk /dev/sda: 931.51 GiB, 1000204886016 bytes, 1953525168 sectors
Disk model:  SN7100 1TB     
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 33553920 bytes
Disklabel type: gpt
Disk identifier: ...

Device       Start        End    Sectors   Size Type
/dev/sda1     2048    2099199    2097152     1G Linux filesystem
/dev/sda2  2099200 1953523711 1951424512 930.5G Linux filesystem
```

### Installing the Kernel and Arch Linux

* [Mount the File Systems](https://wiki.archlinux.org/title/Installation_guide#Mount_the_file_systems)
* [Install Essential Packages](https://wiki.archlinux.org/title/Installation_guide#Install_essential_packages)

#### Mounting the File Systems

Before we can proceed, we first need to mount our previously created boot and system partition.
Otherwise, there would be no way to write data to it, as the disk is physically there, but the filesystem is not "connected".

We are using the `/mnt/boot` directory for the boot partition, and `/mnt` for the system.
Replace the `X` with the letter of your drive, in my case that would be `a`.

```
mount /dev/sdX2 /mnt
mount --mkdir /dev/sdX1 /mnt/boot
```

#### Installing Arch and the Linux Kernel

Essentially, three packages are needed to get a more or less running system.

* `base` - This could simply be called "Arch Linux", as in the core programs, configurations and libraries that make up Arch
* `linux` - A piece of notorious email threads, the [Linux Kernel](https://wiki.archlinux.org/title/Kernel)
* `linux-firmware` - [Linux Firmware](https://wiki.archlinux.org/title/Linux_firmware) contains the firmware for hardware like the CPU

```
pacstrap -K /mnt base linux linux-firmware
```

Congratulations.
At this point, on your partition `sdX2`, you have a fully functioning Arch Linux.
If you were to plug your drive into another machine now, it would not boot up though ...
To get closer to a boot, install the [Microcode](https://wiki.archlinux.org/title/Microcode) for your processor.

* `pacstrap -K /mnt intel-ucode`, if the target computer has an Intel CPU
* `pacstrap -K /mnt amd-ucode`, if the target computer has an AMD CPU

### Make Arch go Boot

* [Configure the System](https://wiki.archlinux.org/title/Installation_guide#Configure_the_system)

#### Creating the fstab

**Note**: In this chapter, we must be truly superuser.
Running _sudo_ won't do, so please run `su` now, if you did not yet.

The first thing we need to do is to create an [fstab](https://wiki.archlinux.org/title/Fstab) file.
Simply put, the _fstab_ file defines how our system is supposed to mount (read: connect) the partitions on our drive.

```
genfstab -U /mnt >> /mnt/etc/fstab
```

We can inspect the contents of the file by running `cat /mnt/etc/fstab` - it should contain our entries.

#### Minimal System Configuration

We need to perform a [chroot](https://wiki.archlinux.org/title/Chroot) into the Arch drive.
Chroot is, in simple terms, to make the root believe that its entire world is only the new Arch installation, and the host system does not exist.

```
arch-chroot /mnt
```

[Vim](https://wiki.archlinux.org/title/Vim),
[Emacs](https://wiki.archlinux.org/title/Emacs) or
[Nano](https://wiki.archlinux.org/title/Nano) are not installed by default in Arch.
Having a text editor makes the life a lot easier, and this guide needs one, so install it via _pacman_.
As a Vim user, I install Vim, and the next commands are provided for Vim.

```
pacman -S vim
```

Setting up time and locale is following precisely the steps from 
[3.3 Time](https://wiki.archlinux.org/title/Installation_guide#Time) and
[3.4. Localization](https://wiki.archlinux.org/title/Installation_guide#Localization),
so I will not copy them here.

Next, we set a hostname for the machine.
This will be the name shown e.g. on the router.

```
vim /etc/hostname
```

Last but not least, we should set a root password.

```
passwd
```

#### Installing the Booatloader

* [Boot Loader](https://wiki.archlinux.org/title/Arch_boot_process#Boot_loader)
* [systemd-boot](https://wiki.archlinux.org/title/Systemd-boot)

**Important:** This needs to be in the _arch-chroot_ environment.

At this point, the Arch Wiki is our friend to understand what the boot loader is and how it works.
In most simple terms, the first software started after/by the UEFI/BIOS is the boot loader.
The boot loader then takes care of starting Linux.

We are using _systemd-boot_ for no specific reason, except some (very little) familiarity from using it on my machine.
It also comes as part of the _base_ package, so we have it at our disposal already.
For a server, the [EFI boot stub](https://wiki.archlinux.org/title/EFI_boot_stub) might be a better choice.

To set up _systemd-boot_, run 

```
bootctl install
```

Here we are diverging from the steps in [Installing the UEFI Boot Manager](https://wiki.archlinux.org/title/Systemd-boot#Installing_the_UEFI_boot_manager).
Per my understanding, in `/boot/loader/entries`, it should contain entries after this command.
However, this folder is empty for me.
If it is not for you, congratulations, and you can likely skip the setup of the Loader Conf and Entry creation.
In case it is, time to artisanal craft the entries.
Credits to
[Use systemd-boot instead of grub in Arch Linux (tsunderechen.io)](https://www.tsunderechen.io/2020/05/archlinux-systemd-boot-installation/),
who's blog post we're following.

##### Creating the Loader Conf

```bash
vim /boot/loader/loader.conf
```

```
default arch    # match the filename of the entry
timeout 5       # the timeout before loading the entry
```

##### Creating the Boot Entry

Creating the boot entry requires to know the UUID of the partition to load/start Linux from/on.
In our case, that would be `/dev/sdX2`, where _X_ is the letter and 2 is the system partition.
We can obtain the partition UUID running 

```
blkid
...
/dev/sdX1: UUID="B1E2-1651" BLOCK_SIZE="512" TYPE="vfat" PARTUUID="137c774b-a0a8-4853-99fc-a40914e49792"
/dev/sdX2: UUID="5d1a6140-013b-4b3d-8ebd-6175ddb5c12f" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="4104fcf9-e1df-4b7f-b19b-c5b0dd6efef3"
```

After locating our partition, we create an entry `arch.conf` with our partition UUID.

```bash
vim /boot/loader/entries/arch.conf
```

```
title  Arch Linux
linux  /vmlinuz-linux
initrd /intel-ucode.img # IMPORTANT: If you use amd, this must be amd-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID=<PUT-PARTUUID-HERE> rw
```

In my case, the options line should look like this:

```
options root=PARTUUID=4104fcf9-e1df-4b7f-b19b-c5b0dd6efef3 rw
```

That's it!
If we were to plug our drive into another computer now, it would boot!

### Make Arch go Network

A server that cannot connect to a network is fairly useless.
The last step of this guide is to set up the network connection.

**Important:** This needs to be in the _arch-chroot_ environment.

#### Network Setup

* [Network Configuration](https://wiki.archlinux.org/title/Network_configuration)

We've read _systemd_ a couple of times now, and to no one's surprise, the network can also be managed with _systemd_.
Arch Linux ships with
[systemd-networkd](https://wiki.archlinux.org/title/Systemd-networkd) and
[systemd-resolved](https://wiki.archlinux.org/title/Systemd-resolved).
_systemd-networkd_ takes care of getting our network connection over IP sorted, whereas _systemd-resolved_ handles DNS.
This guide only covers the Ethernet connection, so please consult the page for _systemd-networkd_ if you require wireless.

A set of preconfigurations is provided in Arch.
To enable the ethernet connection, we can create a symlink, as _systemd-networkd_ adheres to the configs we provide in `/etc/systemd/network/`.

```
ln -s /usr/lib/systemd/network/89-ethernet.network.example /etc/systemd/network/89-ethernet.network
```

Configuration done, last but not least we need to start the services on boot.
To do so, we enable [systemd units](https://wiki.archlinux.org/title/Help:Reading#Control_of_systemd_units) using _systemctl_.

```
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
```

... as this is for a server, it is advised to configure the [Wired adatper using a static IP](https://wiki.archlinux.org/title/Systemd-networkd#Wired_adapter_using_a_static_IP).
We can do so by creating a configuration _20-wired.network_.
In my case, the router's subnetwork is based off of the 24-bit prefix `192.168.8.XYZ`.
If the current host is in the same network as the server will be, using `ip route` can tell what the gateway and prefix is.
Otherwise, it needs to be configured for the (potentially different) target network.

```
vim /etc/systemd/network/20-wired.network
```

```
[Match]
Kind=!*
Type=ether

[Network]
Address=192.168.8.100/24
Gateway=192.168.8.1
DNS=9.9.9.9
DNS=8.8.8.8

```

#### Enabling SSH

* [OpenSSH](https://wiki.archlinux.org/title/OpenSSH)
* [Users and Groups](https://wiki.archlinux.org/title/Users_and_groups)

A server unable to connect to serves little to no value.
That's where SSH comes to the rescue.
Within our chroot, install _OpenSSH_, and enable the SSH Daemon.

```
pacman -S openssh
systemctl enable sshd.service
```

That's already it.

**Important:** This is by no means a secure setup.
Do not make your server accessible from the internet without actually knowing what you are doing.
This guide covers no security concerns and is solely meant for use in an internal network.

Final step:
Unless we allow login as root, we need to create a user.

```
useradd -m my-user-name
passwd my-user-name
```

# Closing Remarks

Installing Arch gets easier over time, and is always an interesting exercise with learnings.
This was probably the first time I actually read the articles in the Arch Wiki.
My sincere recommendation to read them, they offer a great introduction into understanding how Linux works.
