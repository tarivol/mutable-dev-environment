# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "alvistack/ubuntu-25.10"
  
  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"
  config.ssh.insert_key = false

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Disable the default share of the current code directory. Doing this
  # provides improved isolation between the vagrant box and your host
  # by making sure your Vagrantfile isn't accessible to the vagrant box.
  # If you use this you may want to enable additional shared subfolders as
  # shown above.
  # config.vm.synced_folder ".", "/vagrant", disabled: true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  config.vm.provider "virtualbox" do |vb|
   # Display the VirtualBox GUI when booting the machine
   # vb.gui = true

   # Customize the amount of memory on the VM:
   vb.memory = "4096"
   
   # Use 4 CPUs
   vb.cpus = 4
   
   # Enable all USB devices needed for development
   vb.customize ['modifyvm', :id, '--usb', 'on']
   vb.customize ['modifyvm', :id, '--usbehci', 'on']
   vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'STLink', '--vendorid', '0x0483', '--productid', '0x3748']
   vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'STLINK-V3', '--vendorid', '0x0483', '--productid', '0x3753']
   vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'STLINK-V3', '--vendorid', '0x0483', '--productid', '0x374E']
   vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'STLINK-V3', '--vendorid', '0x0483', '--productid', '0x374F']
   vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'Olimex OpenOCD JTAG ARM-USB-TINY-H', '--vendorid', '0x15BA', '--productid', '0x002a']
   vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'Olimex OpenOCD JTAG ARM-USB-OCD-H', '--vendorid', '0x15BA', '--productid', '0x002b']
   vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'Olimex OpenOCD JTAG', '--vendorid', '0x15BA', '--productid', '0x0003']
   vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'AVRISP mkII', '--vendorid', '0x03EB', '--productid', '0x2104']
   vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'FTDI serial adapter', '--vendorid', '0x0403', '--productid', '0x6001']
  end

  # provisioning scripts
  config.vm.provision :shell, path: "0_install-toolchain.sh"
  config.vm.provision :shell, reboot: true
  config.vm.provision :shell, path: "1_install-toolchain_part2.sh"
  config.vm.provision :shell, path: "2_clone-code.sh", args: "https://github.com/tarivol/eurorack", privileged: false
end
