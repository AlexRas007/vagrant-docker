# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"

VAGRANTFILE_API_VERSION ||= "2"
Vagrant.require_version ">= 2.2.0"

# Файл конфигурации
vagrantconfigFileExample = File.expand_path("Vagrantconfig.yaml.example", File.dirname(__FILE__))
unless File.exist? vagrantconfigFileExample then
	puts "Vagrantconfig.yaml.example settings file not found in " + File.dirname(__FILE__)
	exit
end

vagrantconfigPath = File.expand_path("Vagrantconfig.yaml", File.dirname(__FILE__))
unless File.exist? vagrantconfigPath then
	vagrantconfigFileExample = File.new(vagrantconfigPath + ".example","r:UTF-8")

	vagrantconfigFile = File.new(vagrantconfigPath, "w:UTF-8")
	vagrantconfigFile.print(vagrantconfigFileExample.read)
	vagrantconfigFile.close

	vagrantconfigFileExample.close
end

@variables = YAML.load_file(vagrantconfigPath)

require File.expand_path(File.dirname(__FILE__) + "/commands/vm_command.rb")
require File.expand_path(File.dirname(__FILE__) + "/commands/docker_command.rb")

user = "vagrant"
group = "vagrant"
folderFrom = File.dirname(__FILE__)
folderTo = "/home/vagrant/workdir"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	# Переход сразу в рабочею папку при вызове vagrant ssh без параметров
	if ARGV[0] == "ssh" && !ARGV[1]
		config.ssh.extra_args = ["-t", "cd /home/vagrant/workdir; bash --login"]
	end

	# Настройка vagrant
	plugins = ["vagrant-vbguest"];
	if @variables["mount"] == "nfs" then
		if Vagrant::Util::Platform.windows? then
			plugins.push "vagrant-winnfsd"
		end
		plugins.push "vagrant-bindfs"
	elsif @variables["mount"] == "sshfs" then
		plugins.push "vagrant-sshfs"
	end
	config.vagrant.plugins = plugins

	# Настройка виртуальной машины
	config.vm.box = "docker"
  	config.vm.box = "bento/ubuntu-20.04"
	config.vm.hostname = @variables["hostname"]
	config.vm.network :private_network, ip: @variables["ip"]
	config.vm.provider "virtualbox" do |v|
		v.gui = false
		v.name = @variables["hostname"] + ".machine"
		v.memory = @variables["memory"]
		v.cpus = @variables["cpus"]
		v.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
		v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
	end

	# Синхронизация файлов
	config.vm.synced_folder ".", "/vagrant", disabled: true
	if @variables["mount"] == "rsync"
		config.vm.synced_folder folderFrom, folderTo, id: "base-rsync", type: "rsync", rsync__exclude: [
			".git",
			".idea",
			".vagrant",
		], rsync__args: ["--verbose", "--archive", "-z"]
	elsif @variables["mount"] == "nfs"
		config.vm.synced_folder folderFrom, folderTo, id: "base-nfs", type: "nfs", mount_options: ["actimeo=1", "nolock"]
		if Vagrant.has_plugin?("vagrant-bindfs")
			config.bindfs.default_options = {
				force_user: "vagrant",
				force_group: "vagrant",
				perms: "0777", # базовые значения "u=rwD,g=rD,o=rD"
			}
			config.bindfs.bind_folder folderTo, folderTo, "chown-ignore": true, "chgrp-ignore": true, "chmod-ignore": true
		end
	elsif @variables["mount"] == "sshfs"
		config.vm.synced_folder folderFrom, folderTo, id: "base-sshfs", type: "sshfs", owner: user, group: group
	else
		puts "Check your Vagrantgonfig.yaml file, you have no mount specified."
		exit
	end

	# Проброс портов
	port = 0
	while port < 100 do
		portCms = "#{port}0"
		portPhpMyAdmin = "#{port}1"
		if port <= 9
			portCms = "0#{portCms}"
			portPhpMyAdmin = "0#{portPhpMyAdmin}"
		end
		config.vm.network "forwarded_port", guest: "5#{portCms}", host: "50#{portCms}"
		config.vm.network "forwarded_port", guest: "5#{portPhpMyAdmin}", host: "50#{portPhpMyAdmin}"
		port += 1
	end

	# Установка docker
	config.vm.provision "shell", inline: <<-SHELL
		sudo apt-get update
		sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
		sudo apt-get update
		sudo apt-get install -y docker-ce
		sudo usermod -aG docker vagrant
	SHELL

	# Установка docker-compose
	config.vm.provision "shell", inline: <<-SHELL
		sudo curl -L "https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		sudo chmod +x /usr/local/bin/docker-compose
	SHELL

	# Настройки плагинов
	if Vagrant.has_plugin?("vagrant-vbguest")
		config.vbguest.auto_update = false
		config.vbguest.no_remote = true
		config.vbguest.iso_path = "https://download.virtualbox.org/virtualbox/%{version}/VBoxGuestAdditions_%{version}.iso"
	end

	if Vagrant.has_plugin?("vagrant-cachier")
		config.cache.scope = :box
	end
end
