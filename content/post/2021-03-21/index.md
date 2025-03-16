---
title: Read Temperature & Humidity with RaspberryPi 4
description: Using the DHT11/22 on RaspberryPi 4 to track temperature and humidity.
slug: 2021-raspberry-pi-four-dht
date: 2021-03-21 11:00:00+0000
categories:
    - Tech
tags:
    - RaspberryPi
weight: 1
---
I recently bought a RaspberryPi 4 and installed Ubuntu Server 20.04 64 Bit on it. There are many tutorials available how to read the temperature/humidity via Python, unfortunately none of them worked out of the box. It seems to be that they are
- either for Raspbian OS
- or for 32 Bit OSes.

After some searching I found a way from several sources to make it run. This is a horrible hacky workaround and I'd be very happy to see a better way and/or out-of-the-box solution.

# Prerequisites

- [Ubuntu Server 20.04.2 LTS](https://ubuntu.com/download/raspberry-pi)
- Python 3 (preinstalled in aforementioned Ubuntu image)
- DHT11/DHT22 **with 4 Pins** connected to the Pi (follow [this guide](https://pimylifeup.com/raspberry-pi-humidity-sensor-dht22/) to see the wiring)
- [dht.py](dht.py) (Source code from [learn.adafruit.com](https://learn.adafruit.com/dht-humidity-sensing-on-raspberry-pi-with-gdocs-logging/python-setup))

# Installation

## 1. Install Python 3 Pip

We will use [adafruit-circuitpython-dht](https://pypi.org/project/adafruit-circuitpython-dht/) to read out the sensor and install it via `pip`. Run below command from the shell.

```bash
sudo apt install python3-pip
```

## 2. Install `RPi.GPIO` via apt-get

Usually this is a dependency to `adafruit-circuitpython-dht` and thus _could_ be installed with it. Unfortunately it does not succeed installing the dependency, so we need to install it ourself. For more information see [this thread](https://askubuntu.com/questions/1290037/error-while-installing-rpi-gpio-as-error-command-errored-out-with-exit-status) on [askubuntu.com](askubuntu.com). Run below command from the shell.

```bash
sudo apt-get install RPi.GPIO
```

## 3. Install `adafruit-circuitpython-dht`

```bash
sudo pip3 install adafruit-circuitpython-dht
```

## 4. Install `libgiod`

This step is a bit ugly. Basically the default installation did not succeed for me, and I ended up finding that [this solution on GitHub](https://github.com/adafruit/Adafruit_CircuitPython_DHT/issues/44#issuecomment-671587227) worked yet slightly modified. 

### 4.1. Install and build `libgpiod`
```bash
sudo apt install libgpiod-dev git build-essential
git clone https://github.com/adafruit/libgpiod_pulsein.git
cd libgpiod_pulsein/src
make
```

You should see a new folder named `libgpiod_pulsein`. Run the script `dht.py` (linked in the prerequisites) and you should see some similar error:

```
Traceback (most recent call last):
  File "run.py", line 11, in <module>
    dhtDevice = adafruit_dht.DHT11(board.D16)
  File "/usr/local/lib/python3.8/dist-packages/adafruit_dht.py", line 265, in __init__
    super().__init__(True, pin, 18000, use_pulseio)
  File "/usr/local/lib/python3.8/dist-packages/adafruit_dht.py", line 56, in __init__
    self.pulse_in = PulseIn(self._pin, 81, True)
  File "/usr/local/lib/python3.8/dist-packages/adafruit_blinka/microcontroller/bcm283x/pulseio/PulseIn.py", line 67, in __init__
    self._process = subprocess.Popen(cmd)
  File "/usr/lib/python3.8/subprocess.py", line 854, in __init__
    self._execute_child(args, executable, preexec_fn, close_fds,
  File "/usr/lib/python3.8/subprocess.py", line 1702, in _execute_child
    raise child_exception_type(errno_num, err_msg, err_filename)
FileNotFoundError: [Errno 2] No such file or directory: '/usr/local/lib/python3.8/dist-packages/adafruit_blinka/microcontroller/bcm283x/pulseio/libgpiod_pulsein'
```

Of particular interest for us is the last line. The file exists, but Python cannot see/access it. Unfortunately granting Python any rights does not solve this problem either. So we need to replace it by the previous build and then grant python correct rights.

The path might be different on your computer, so don't blindly copy & paste the next steps but in case it differs use path from your output.

### 4.2. Replace `libgpiod` with build

Go into the directory `libgpiod_pulsein/src/` from step 4.1. and run the following command from there (**important**: Replace the path if it differs).

```bash
sudo cp libgpiod_pulsein /usr/local/lib/python3.8/dist-packages/adafruit_blinka/microcontroller/bcm283x/pulseio/libgpiod_pulsein
```

### 4.3. Set `suid` for Python

If you run `dht.py` again, it will show you the same error as before. We need to allow any user to run `python` with the same rights as the owner, which is `root`. It is done via [setuid](https://en.wikipedia.org/wiki/Setuid). This solution was posted on [armbian.com](https://forum.armbian.com/topic/8714-gpio-not-working-for-non-root/?do=findComment&comment=65434).
**Please note**: It is very dangerous to grant these rights to Python. So you should rather copy your Python Binary and change only the copy. See the linked solution for doing so.

As I have Python 3.8 on my machine, my Python Binary is found in `/usr/bin/python3.8`. To enable `setuid`, run the following command:

```bash
sudo chmod 4775 /usr/bin/python3.8
```

# Read Sensor Data

Everything set up, so we are ready to read the data. You need to alter the script `dht.py` in line `8`, depending on your GPIO Pin and Sensor:

```python
# VE    - DHT version, e.g. 11 or 22
# PIN   - GPIO Pin the board is connected to, e.g. D4 = GPIO Pin 4
#                           VE       PIN
dhtDevice = adafruit_dht.DHT22(board.D4)
```

It should now start without any errors and print output similar (different values) to that.
```
➜  ~ python dht.py
Temp: 66.2 F / 19.0 C    Humidity: 32% 
Temp: 68.0 F / 20.0 C    Humidity: 33% 
Temp: 68.0 F / 20.0 C    Humidity: 33% 
Temp: 68.0 F / 20.0 C    Humidity: 33% 
```