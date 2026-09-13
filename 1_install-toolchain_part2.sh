#!/usr/bin/env bash

# set -x

echo "STARTING second script"

export DEBIAN_FRONTEND=noninteractive

apt-get update -qq
apt --fix-broken install -yqq
apt auto-remove -yqq
apt full-upgrade -yqq

# Install openocd
echo "Installing OpenOCD"
cd /home/vagrant
# wget -nv https://downloads.sourceforge.net/project/openocd/openocd/0.12.0/openocd-0.12.0.tar.gz --no-check-certificate
# tar xfz openocd-0.12.0.tar.gz
# cd openocd-0.12.0
git clone --depth=1 --branch openocd-cubeide-r7 https://github.com/STMicroelectronics/OpenOCD.git
cd OpenOCD
export CFLAGS="-Wno-error=calloc-transposed-args"
./bootstrap
./configure --enable-ftdi --enable-stlink
make
make install
cd /home/vagrant

echo "Installing STLink"

# Install stlink
cd /home/vagrant
wget -nv https://github.com/texane/stlink/archive/v1.8.0.tar.gz --no-check-certificate
tar xfz v1.8.0.tar.gz
cd stlink-1.8.0
make clean
make release
make install
cp -a config/udev/rules.d/* /etc/udev/rules.d/
udevadm control --reload-rules
udevadm trigger
cd /home/vagrant


echo "Adding udev rules"
# Allow non-root users to access USB devices such as Atmel AVR and Olimex
# programmers, FTDI dongles...
echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="15ba", ATTRS{idProduct}=="0003", GROUP="users", MODE="0666"' >> /etc/udev/rules.d/60-programmers.rules
echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="15ba", ATTRS{idProduct}=="002a", GROUP="users", MODE="0666"' >> /etc/udev/rules.d/60-programmers.rules
echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="15ba", ATTRS{idProduct}=="002b", GROUP="users", MODE="0666"' >> /etc/udev/rules.d/60-programmers.rules
echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2104", GROUP="users", MODE="0666"' >> /etc/udev/rules.d/60-programmers.rules
echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3753", GROUP="users", MODE="0666"' >> /etc/udev/rules.d/60-programmers.rules
echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", GROUP="users", MODE="0666"' >> /etc/udev/rules.d/60-programmers.rules
echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", GROUP="users", MODE="0666"' >> /etc/udev/rules.d/60-programmers.rules
echo 'SUBSYSTEMS=="usb", KERNEL=="ttyUSB*", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", GROUP="users", MODE="0666", SYMLINK+="ftdi-usbserial"' >> /etc/udev/rules.d/60-programmers.rules
udevadm control --reload-rules
udevadm trigger

echo "Installing arm toolchain"
# Install toolchain for STM32F
cd /home/vagrant
wget -nv https://launchpad.net/gcc-arm-embedded/4.8/4.8-2013-q4-major/+download/gcc-arm-none-eabi-4_8-2013q4-20131204-linux.tar.bz2 --no-check-certificate
tar xjf gcc-arm-none-eabi-4_8-2013q4-20131204-linux.tar.bz2
mv gcc-arm-none-eabi-4_8-2013q4 /usr/local/arm-4.8.3/
# (We're progressively checking that all STM32F1 projects can also be built with
# this gcc version instead of 4.5.2).
ln -s /usr/local/arm-4.8.3 /usr/local/arm

# Add "." to PYTHONPATH, and set default language
echo 'export LC_ALL=en_US.UTF-8' >> /home/vagrant/.bashrc
echo 'export LANGUAGE=en_US' >> /home/vagrant/.bashrc
echo 'export PYTHONPATH=.:$PYTHONPATH' >> /home/vagrant/.bashrc
