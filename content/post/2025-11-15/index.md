---
title: Wayland, Sway, Nvidia DLSS, Unreal Engine and Ghosting
description: >
    TL;DR: Install KDE, GNOME or another DE to resolve ghosting.
slug: 2025-wayland-sway-nvidia-dlss-unreal-engine-and-ghosting
date: 2025-11-15 10:00:00+0000
categories:
    - Tech
tags:
    - Linux
    - Arch Linux
keywords:
    - Linux
    - Arch Linux
weight: 1
---

Since January 2023, I'm the owner of a Steam Deck.
Until April 2025, my main computer still had Windows running, but I found that I hardly use it for anything but the browser and games.
Given the Steam Deck experience, I was confident to ditch Windows and continue playing on Linux from here on.
Especially as pretty much anything I play is on Steam.
However, in my setup with an Nvidia RTX 3070 and Sway (thus Wayland), heavy ghosting occurred on games like _Hogwarts Legacy_, and one I started most recently, _Arc: Raiders_.
Overall, these problems seem to happen with games that are built in _Unreal Engine_, as e.g. _RDR2_ or _GTA V_ work flawlessly.

The TL;DR of this article is pretty much the only thing that helped me resolving it.
Given that I did countless searches to find out how that would be resolvable under Sway, this article is more to prevent others wasting hours of their life to try to fix it, if they are content to just install a Desktop Environment alongside Sway, just for gaming.

In case anyone ever finds the correct way to get rid of ghosting in Unreal Engine under Sway, please reach out!
I would be more than happy to update this piece, and get rid of a DE.

## What is Ghosting?

This is by no means a formal definition.
A lot of people know ghosting from their computer screens, especially some lower-budget IPS screens suffer from it.
Simply put, one does not only see the most recent rendered image, but sees images from previous frames too.
During a game, when you move, it could look like this
(Source: [DLSS 2.3: Has Nvidia Fixed Ghosting Issues in Games? (YouTube)](https://www.youtube.com/watch?v=3kIJOTfOG8s)):

![Ghosting (from channel "Hardware Unboxed")](ghosting.webp)

Instead of seeing just one car, multiple last positions are still drawn.

## Nvidia DLSS

Nvidia **D**eep **L**earning **S**uper **S**ampling ([DLSS (Wikipedia)](https://en.wikipedia.org/wiki/Deep_Learning_Super_Sampling)) is used in games to achieve two things:

1. FPS goes brrrrrt (much like more RGB = more FPS) by rendering at a lower resolution, and then upscaling, with - the claim of - almost no loss of detail,
2. [anti-aliasing (Wikipedia)](https://en.wikipedia.org/wiki/Anti-aliasing), often abbreviated AA.

However, the internet is full of people encountering ghosting with DLSS.

**Important Note:** Initially, I _thought_ that DLSS would be my issue.
But I want to be very clear that even with AA off in these games (or as off as it could be), the ghosting still occurred.

## Sway, Wayland

### Sway and Nvidia

Sway is a window manager under Linux, that is often stated as the successor for i3.
Whilst i3 still uses X11, Sway uses Wayland, which itself is considered the successor of X11.
In most simple terms, Sway new, i3 old, Wayland new, X11 old.
I gave a quick guide on how to install Sway in [Arch and i3 - Hello, Sway!](http://localhost:1313/p/2025-arch-and-i3-hello-sway-install-arch-and-sway/).

Nvidia and Sway don't go along all too well.
So unwell, that Sway forces you to run it with the a flag [--unsupported-gpu (Arch Wiki)](https://wiki.archlinux.org/title/Sway).
Being a daily user, it's easy to notice small glitches and hiccups here and there, which one would expect when providing this flag.
As it does not bother(ed) me (until now), there was never a need to do something about it.

### Sway and Multiple Monitors

My host device is a laptop, put up on a desk and then connected via a 10m (almost 33 foot) cable to my TV.
The laptop screen is not used at all.
To turn off the laptop screen after launching, and only render on the TV, I use [shikane (GitHub)](https://github.com/hw0lff/shikane).

```
.config/shikane/config.toml
```

```toml
[[profile]]
name = "tv_setup"

[[profile.output]]
enable = true
search = ["m=LG TV SSCR2", "s=0x01010101", "v=LG Electronics"]
mode = "2560x1440@119.998Hz"
position = "0,0"
scale = 1.0
transform = "normal"
adaptive_sync = false

[[profile.output]]
enable = false
search = ["m=0x1600", "s=", "v=California Institute of Technology"]
mode = "2560x1600@165.019Hz"
position = "0,0"
scale = 1.0
transform = "normal"
adaptive_sync = false
```

```
.config/sway/config
```

```
...
exec shikane
...
```

The TV's resolution is 4k, but the RTX 3070 on Lenovo's Legion supports only 2k@120Hz, and anyway, on a 4k screen you can't really see anything without scaling.

```
swaymsg -t get_outputs
```

```
Output DP-1 'LG Electronics LG TV SSCR2 0x01010101' (focused)
...
  Allow tearing: no
  Available modes:
    3840x2160 @ 60.000 Hz
    4096x2160 @ 59.940 Hz
```

My _guess_ is that this has to do with Sway's compositor and tearing being off.
It's a wild guess, but somehow Sway and the graphics renderer must compete about who gets to paint the image when.
Since DLSS was turned off, and it stil suffered heavy ghosting, this cannot just come from Nvidia.
However, given I'm using an _unsupported GPU_, whatcha gonna do?

## The Fix

I tried all kind of things and guides I could find online.
Nothing helped, nothing worked, nothing wanted to work.
Eventually, the thought struck me to just try out another desktop environment and see if that does the job.
A list of officially supported DEs in Arch can be found in [Desktop Environments (Arch Wiki)](https://wiki.archlinux.org/title/Desktop_environment).

### <u>Caution!</u>

When you install a DE, it'll install _a shitload_ of other tools.
This probably has an impact on your Sway experience, e.g. the File Manager may change, or some GTK configs are messed with, or . . . the list goes on.
You can always `sudo pacman -Rns` what you installed, but make sure that your configs are backed up before you proceed.

### Installation

TL;DR: 

```shell
sudo pacman -S plasma-desktop
```

Note: Install `plasma` first to get all the tooling for e.g. monitor setup.
Boot into KDE, then configure everything.
Uninstall KDE then (`pacman -Rns plasma`) and then install `plasma-desktop`.
Enjoy a preconfigured KDE Plasma, but with a lot less overhead.

I used KDE Plasma, as it is the same DE that the Steam Deck uses.
Besides that, I tried GNOME, Cinnamon, Xfce4 and MATE.
Some of them I did not even get to boot without configuring

Now I can enjoy ghost free gaming.
It's too late for Halloween anyways.
