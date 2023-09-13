# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

    #================#
    #  CentOS Nodes  #
    #================#
    
    #ansible - node01
    # config.vm.define "ansible-node01" do |cfg|    
    #   cfg.vm.box = "centos/7"
    #   cfg.vm.provider "virtualbox" do |vb|
    #     vb.name = "Ansible-Node01(github_SysNet4Admin)" 
    #     vb.memory = "2048"
    #     vb.cpus = 2
    #   end
    #   cfg.vm.host_name= "ansible-node01" 
    #   cfg.vm.network "public_network", ip: "192.168.0.126"
    #   cfg.vm.network "forwarded_port", guest:22, host:60011, auto_correct: true, id: "ssh"
    #   cfg.vm.synced_folder "../data","./vagrant", disabled: true
    #   cfg.vm.provision "shell", path: "bash_ssh_conf_4_CentOS.sh"
    # end

#================#
#  Master Node   #
#================#

    config.vm.define "k8s-master" do |cfg|    
      cfg.vm.box = "ubuntu/focal64"
      cfg.vm.provider "virtualbox" do |vb|
        vb.name = "k8s-master" 
        vb.cpus = 2
        vb.memory = "2048"
        vb.customize ["modifyvm", :id, "--groups", "/k8s-cluster"]
      end
      cfg.vm.host_name= "master" 
      cfg.vm.network "private_network", ip: "192.168.56.103"
      cfg.vm.network "forwarded_port", guest:22, host:60014, auto_correct: true, id: "ssh"
      cfg.vm.synced_folder "../data","./vagrant", disabled:true
      cfg.vm.provision "shell", path: "init.sh"
      cfg.vm.provision "shell", path: "master.sh"
    end

    
#================#
#  Worker Nodes  #
#================#

    config.vm.define "k8s-worker" do |cfg|    
      cfg.vm.box = "ubuntu/focal64"
      cfg.vm.provider "virtualbox" do |vb|
        vb.name = "k8s-worker" 
        vb.cpus = 2
        vb.memory = "2048"
        vb.customize ["modifyvm", :id, "--groups", "/k8s-cluster"]        
      end
      cfg.vm.host_name= "worker" 
      cfg.vm.network "private_network", ip: "192.168.56.104"
      cfg.vm.network "forwarded_port", guest:22, host:60015, auto_correct: true, id: "ssh"
      cfg.vm.synced_folder "../data","./vagrant", disabled:true
      cfg.vm.provision "shell", path: "init.sh"
      cfg.vm.provision "shell", path: "worker.sh"
    end
    

end
