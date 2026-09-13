#!/usr/bin/env bash

# set -x

# fix apt warnings like:
# ==> default: dpkg-preconfigure: unable to re-open stdin: No such file or directory
# http://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export DEBIAN_FRONTEND=noninteractive

echo "STARTING script"

echo "Reconfigure locales"
# Removing unneeded additional language packs to shorten time of locale reconfigure
apt purge -y language-pack-en language-pack-en-base

echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections
echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections
dpkg-reconfigure --frontend=noninteractive locales

# if test -n "$(find /vagrant/custom_certs -maxdepth 1 -name "*.crt" -print -quit)"; then
# 	echo "Enabling custom certificates..."
# 	sudo cp /vagrant/custom_certs/*.crt /usr/local/share/ca-certificates/
# 	sudo update-ca-certificates
# fi

# The Box I am basing on has some weird additional APT repositories, that clashes
# with some Python libraries.
sudo rm /etc/apt/sources.list.d/home-alvistack*.sources

echo "Installing Kernel packages"
# Install some additional drivers, including support for FTDI dongles
# http://askubuntu.com/questions/541443/how-to-install-usbserial-and-ftdi-sio-modules-to-14-04-trusty-vagrant-box
apt-get update -qq
apt-get install -y linux-image-extra-virtual
modprobe ftdi_sio vendor=0x0403 product=0x6001

# Install basic development tools
echo "Installing basic development packages"
dpkg --add-architecture i386
apt-get update -qq
apt-get upgrade -y
apt-get install -y build-essential cmake libtool \
	autotools-dev autoconf pkg-config libusb-1.0-0 libusb-1.0-0-dev \
	libftdi1 libftdi-dev git libc6:i386 libncurses6:i386 libstdc++6:i386 \
	cowsay figlet language-pack-en

# Install python
echo "Installing python packages"
apt install -y python-is-python3 python3-platformdirs=4.3.7-1 python3-fs python3-fonttools python3-matplotlib --allow-downgrades
apt --fix-broken install -y
apt auto-remove -y
apt full-upgrade -y

# Install development tools for avr
echo "Installing AVR devtools"
apt-get install -y gcc-avr binutils-avr avr-libc avrdude

echo "Regenerating locales again"
echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections
echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections
dpkg-reconfigure --frontend=noninteractive locales

# The makefile from Mutable Instruments expects the avr-gcc binaries to be
# in a different directory.
ln -s /usr /usr/local/CrossPack-AVR
