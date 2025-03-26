---
title: Arch and i3 - Hello, Sway! - Install Arch and Sway
description: >
    Curiosity made me install Sway. 
    We cover the installation on a laptop with an Nvidia Graphics Card. 
slug: 2025-arch-and-i3-hello-sway-install-arch-and-sway
date: 2025-03-26 18:00:00+0000
categories:
    - Tech
tags:
    - Linux
    - Arch
    - Sway
weight: 1
---

Welcome to part one of the three-part series "Hello, Sway!"
The series is split into 

1. <i>Arch & Sway setup using `archinstall`</i>
1. Sway Configuration
1. Linux QoL Tools

## Motivation

For a while already, there has been no real reason for me to keep Windows.
The doubt started about two years ago, in January 2023, when I got myself a Steam Deck.
Although the purchase was mostly to emulate console and handheld games, of course the question was 
"[But Can It Run Crysis?](https://knowyourmeme.com/memes/but-can-it-run-crysis)"
To my surprise, the games I tried performed incredibly well, almost all of them out of the box.
Thanks to ProtonDB, if there was a title that needed some extra configuration, it is usually there.

Besides gaming, my work is either on a Mac or (used to be) on a Linux machine.
When using Linux at work, the default for me was to set up Arch and i3wm (I use Arch btw).
Moreover, after being a nano user for quite a while, it was time to move to vim.
It's a nice coincidence that Sway uses vim keybinds for moving windows, although one could easily configure that in i3wm.

Given the circumstances, let's move to Linux! 

## Arch & Sway setup using `archinstall`

[archinstall](https://github.com/archlinux/archinstall) is a guided installer to setup Arch.
There are many posts on how to create a bootable USB stick with Arch, and how to run archinstall.
Thus, instead of providing all the steps here, you may want to follow e.g. this one on debugpoint.com:
[Installing Arch Linux Using archinstall Automated Script](https://www.debugpoint.com/archinstall-guide/)
**up to the point of installing the Desktop Environment**.

Before looking into what to select, first comes two common issues, one often faced on laptops and the other may faced when running on an Nvidia card.
Scroll past that to [Sway, Ly Greeter and Graphics Driver](./#sway-graphics-driver-and-ly) in case you don't encounter any issues.

### Issues During Archinstall 

#### Archinstall boots into a Blackscreen on Nvidia

It may happen that with Nvidia Graphics Cards, once you select Arch Linux Install from the bootmedium, you only see a blank black screen.
In that case, try to add `nomodeset`.

1. Select the entry on the USB stick you want to boot from, then press `e`.
1. Navigate your cursor to the end of the line, and append ` nomodeset`.

This should resolve the issue.
If you're curious what exactly this does, feel free to read this post on ubuntuforums.com:
[How to set NOMODESET ant other kernel boot options in grub2](https://ubuntuforums.org/showthread.php?t=1613132)

#### Cannot connect to Wifi

This issue is common on Laptops.
To connect to the WiFi, one may use `iwctl` (as suggested). 
Trying to turn on the WiFi could result in `operation failed`. 

To fix this, run

```shell
rfkill unblock all
```
and then retry.

For further reading on why and how, see [rfkill caveat (ArchWiki/NetworkConfiguration)](https://wiki.archlinux.org/title/Network_configuration/Wireless#Rfkill_caveat).

### Sway, Graphics Driver and Ly

On the desktop environment installation, select the following

#### Desktop - Sway

This one goes without saying.

#### Graphics Driver

For the Graphics Driver, it depends on your Graphics Card.
As my laptop has an RTX 3070, which is newer than Turing, I chose the "Nvidia (open kernel ...)".
To find which Nvidia driver you need, please consult [ArchWiki/NVIDIA](https://wiki.archlinux.org/title/NVIDIA).

#### Greeter - Ly 

My setup uses Ly as the greeter.
This greeter takes you to the next level.
Check it out on [github.com/fairyglade/ly](https://github.com/fairyglade/ly).

Now, finish up the installation, and boot into your system.

### Start Sway - Nvidia Unsupported GPU

As mentioned in the Arch Wiki, to start Sway with Nvidia drivers, one must explicitly state that this is an unspported GPU
([ref](https://wiki.archlinux.org/title/Sway)).
Edit the Sway Desktop file

```shell
vim /usr/share/wayland-sessions/sway.desktop
```

and change the Exec line to

```txt
Exec=sway --unsupported-gpu
```

Logout, select Sway, and start it ... aaand you may see a black screen.
At least that happened when I did this, and I don't have an explanation for this, as in, why it is fixed after a reboot.
In case that doesn't happen: Great.
If it happens though, reboot, and then - at least on my machine™ - it worked.

----

Congratulations.
You most likely have an Arch & Sway setup with a fancy login screen now.
In the next post, we'll look into some tools to get simple Sway configuration with most important things sorted.
