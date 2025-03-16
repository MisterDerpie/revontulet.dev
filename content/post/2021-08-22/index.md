---
title: Ubuntu and i3 on Lenovo Legion 5 Pro
description: A short summary on how to install Ubuntu on the Lenovo Legion 5 Pro.
slug: 2021-lenovo-legion-ubuntu
date: 2021-08-22 15:00:00+0000
categories:
    - Tech
tags:
    - Linux
weight: 1
---

During my summer vacation, I got myself a Lenovo Legion 5 Pro, powered by an AMD Ryzen 7 5800H and an Nvidia RTX3070.
Though this post is not about the legion, I have to say it is an awesome laptop.
What this post is about is how to make Ubuntu with [i3wm](https://i3wm.org/) run on the Lenovo Legion.

## Installing Ubuntu

### Create Bootable USB Media

You need a USB stick as well as a Ubuntu ISO image.
Plenty of tutorials exist on the web to create a bootable Ubuntu USB stick.
Ubuntu.com provides official documentation, coming from a device running
[Windows](https://ubuntu.com/tutorials/create-a-usb-stick-on-windows#1-overview),
[Ubuntu](https://ubuntu.com/tutorials/create-a-usb-stick-on-ubuntu#1-overview) or [Mac OS X](https://ubuntu.com/tutorials/create-a-usb-stick-on-macos#1-overview).

### Boot USB Media

Once you created your boot device, boot up the Legion and press `F12` to get into the boot menu.
From there, select the USB stick.

Next you are presented with the GRUB interface, where you have to select `Ubuntu (safe graphics)` and then press `RETURN`.
After a while (length of the while depends on the speed of your USB stick) you should see a window asking whether you want to `Try` or `Install` Ubuntu.
Select `Install Ubuntu`.

There is only one part in the installer you need to select a certain option to not run into issues.
At some point you should be asked whether you want to have a `Normal Installation` or `Minimal Installation`.
See [this image](https://ubuntu.com/tutorials/install-ubuntu-desktop#5-prepare-to-install-ubuntu) in the official guide.
In the bottom of the window, below `Other options`, you have to select `Install third-party software`.
This is necessary to install the proprietary Nvidia driver.
If you don't, you will most likely be presented a black screen after booting into Ubuntu.

Finish the installation and reboot into Ubuntu.

## i3

### Install i3

Once you booted to your freshly installed Ubuntu, it is very straightforward to install i3.
Run this command in your `Terminal`.

```bash
sudo apt install i3
```

That's already it. 

### Replace gdm

The next step is to replace [GNOME Display Manager](https://wiki.gnome.org/Projects/GDM), abbreviated `gdm`.
We will replace it with [LightDM](https://github.com/canonical/lightdm).
It is as easy as installing i3.

```bash
sudo apt install lightdm
```

At some point during the installation, a window pops up in your terminal, asking you to select your display manager.
In the list, use the arrow keys to navigate to `lightdm` and hit `RETURN` to confirm.

If you ever want to go back to gdm, you can do so by running below command.

```bash
sudo dpkg-reconfigure gdm3
```

### Why replace gdm?

This is the part where I ran into a problem that may only be with my setup.
When having multiple screens connected (1 over HDMI, 1 over Lenovo Dock), I could login to i3 but then everything was frozen.
But it was not Linux that froze, as I could tell from the clock continuing to run.
Logging into Gnome worked though.
Also, logging into Gnome before logging into i3 made it work.
But neither do I want to use Gnome nor do I want to take extra steps every time I boot Linux.
So I tried back and forth, and the only way I got this to work is to use lightdm over gdm.

The fact that I wasted quite some time on this motivated me sharing a short blog post.
Using a different display manager might not suit everyone, but probably for most users this does the job.