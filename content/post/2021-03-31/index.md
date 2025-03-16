---
title: Read Temperature & Humidity with RaspberryPi 4 - Docker Setup
description: Using the DHT11/22 with Docker on RaspberryPi 4 to track temperature and humidity.
slug: 2021-raspberry-pi-four-dht-docker
date: 2021-03-31 22:00:00+0000
categories:
    - Tech
tags:
    - RaspberryPi
    - Docker
weight: 1
---

In my previous post, I showed how to enable the Raspberry Pi 4 on Ubuntu Server to read out DHT11/DHT22 sensor data. But this is a very hacky solution. Moreover is the Raspberry Pi cluttered with some stuff, that we may need to configure differently for another setup or remove as a whole. It's a nice coincidence that I'm currently reading [Docker in Action, Second Edition](https://learning.oreilly.com/library/view/docker-in-action/9781617294761/) (Manning, 2019), so I wanted to build a docker image to read out the data. There are some images available for this already, but I still wanted to build my own light-weight image.

Enough foreword, let's jump right in.

## Prerequesites

* Raspberry Pi 4 with Docker installed (`curl https://get.docker.com/ | sh`)
* DHT11/22 connected with your RapsberryPi (find any guide online for wiring)

## Build Base Image

### Interactively in a Container

This section is to interactively build the base docker image. If you want to get a Dockerfile right away, see the next section.

#### Start Container

As base we use `python:3.7-alpine`, as it is a comparatively very small image with only `41 MB` size. We start the alpine shell `/bin/ash` and to attach us to the container we use the `-it` parameter. The `--name dht` parameter is to find the container by a predefined name.

```bash
docker container run -it --name dht python:3.7-alpine /bin/ash
```

The shell should now look like below. We're now running as a root user in the container.

```
/ #
```

#### Install Build Dependencies

##### Build Tools

To build all dependencies we need to be able to build the python lib `RPi.GPIO`.

Run 

```bash
apk update && apk upgrade
apk add g++ python3-dev
```

to install the build tools.

##### RPi.GPIO

It cost me some headache and searching around how I get this to build, as I always got errors that `gcc` exited with `status code 1`. Luckily I stumbled upon a post in [https://archlinuxarm.org/forum/viewtopic.php?p=64598#p64598](https://archlinuxarm.org/forum/viewtopic.php?p=64598#p64598) by user `peiyangxie` who gave a one liner how to do this. So let's do it, run 

```bash
CFLAGS="-fcommon" pip3 install RPi.GPIO
```

in the container. This will install `RPi.GPIO`.

##### adafruit-circuitpython-dht

Last but not least we need to install the library `adafruit-circuitpython-dht`. Do this by running

```bash
pip3 install adafruit-circuitpython-dht
```

##### Clean up

As we do not need `g++` and `python3-dev` anymore, we should remove them to shrink container size. 

```bash
apk del g++ python3-dev
```

Then exit the container and return to the host shell.

##### Build Image from Container

It remains to build the image from the container. This is easily done by

```bash
docker container commit dht dht-image
```

and then remove the container

```bash
docker container rm dht
```

### Via Dockerfile

To build `dht-image` automatically, just create a file called `Dockerfile` and put below input in it.

```Dockerfile
FROM python:3.7-alpine

RUN apk update && apk upgrade
RUN apk add g++ python3-dev
## See https://archlinuxarm.org/forum/viewtopic.php?p=64598#p64598
RUN CFLAGS="-fcommon" pip3 install RPi.GPIO
RUN pip3 install adafruit-circuitpython-dht
RUN apk del g++ python3-dev
ENTRYPOINT ["/bin/ash"]
```

Navigate to the place the Dockerfile is located and run

```bash
docker image build -t dht-image .
```

to build the image.

## Read DHT with `dht-image`

If you completed the aforementioned section you should have an image called `dht-image`. Let's verify this.

```bash
docker images
```

It should print out a list of images, which contains `dht-image` (most likely at the top).

In the previous post I shared a script [dht.py](https://revontulet.dev/p/2021-raspberry-pi-four-dht/dht.py) which we will first download into the container and then change the pin/sensor according to our needs. Finally we run the script and should get results from our sensor.

**Note**

Docker is not able to access the GPIO pins unless we give it acces. There is a really good, short and comprehensive way about the best options we have on [stackoverflow.com/a/48234752](https://stackoverflow.com/a/48234752). We will use the second option and add `/dev/gpiomem` as a device to our container, as it is the easiest and most sensible option for our needs.


#### Start Container

We start the container with `/dev/gpiomem` as a device and run `/bin/ash` in it.

```bash
docker container run --device /dev/gpiomem -it dht-image /bin/ash
```

#### Download dht script

Download the [dht.py](https://misterderpie.com/assets/scripts/2021-03-21-raspberry-four-dht/dht.py) script via

```bash
wget https://misterderpie.com/assets/scripts/2021-03-21-raspberry-four-dht/dht.py
```

#### Adjust dht script to wiring

The line we need to change is line `8`. If you are familiar with `Vi` you could easily do that, but in case you are not this is also achievable with a single `sed` command (Source: [stackoverflow.com](https://stackoverflow.com/a/11145362)). Run the following command with
- `{X}` - 11 or 22 (DHT version)
- `{Y}` - Your GPIO Pin 

```bash
sed -i '8s/.*/dhtDevice = adafruit_dht.DHT{X}(board.D{Y})/' dht.py
```

so for instance, I have a DHT11 and it is connected to Pin 4, so I would run

```bash
sed -i '8s/.*/dhtDevice = adafruit_dht.DHT11(board.D4)/' dht.py
```

#### Run dht script

This is the easiest step. Just execute it via

```bash
python3 dht.py
```

and you should start seeing output.

I do not know why, but this is failing a lot more often than running directly on the Pi. So you most likely see something like this

```
/ # python3 dht.py 
Checksum did not validate. Try again.
Checksum did not validate. Try again.
Temp: 69.8 F / 21.0 C    Humidity: 20% 
Checksum did not validate. Try again.
A full buffer was not returned. Try again.
Temp: 69.8 F / 21.0 C    Humidity: 20% 
Checksum did not validate. Try again.
Checksum did not validate. Try again.
```

Anyway, here we are, having a working docker image in place that returns (most of the times) the results from the sensor.