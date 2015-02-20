# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "nrel/CentOS-6.5-x86_64"
  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    v.cpus = 1
  end

  config.vm.define "master" do |server|
    server.vm.host_name = "master"
    server.vm.network "private_network", ip: "192.168.250.100"
    server.vm.network "forwarded_port", guest: 80, host: 3000
    server.vm.synced_folder "loadbalancer/", "/srv/salt/loadbalancer/"
    server.vm.provision "shell", inline: "sudo bash"
    server.vm.provision "shell", inline: "service iptables stop"
    server.vm.provision "shell", inline: "rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm"
    server.vm.provision "shell", inline: "echo '192.168.250.100 salt' >> /etc/hosts"
    server.vm.provision "shell", inline: "yum install salt-master -y"
    server.vm.provision "shell", inline: "chkconfig salt-master on"
    server.vm.provision "shell", inline: "service salt-master start"
    server.vm.provision "shell", inline: "yum install salt-minion -y"
    server.vm.provision "shell", inline: "chkconfig salt-minion on"
    server.vm.provision "shell", inline: "echo 'master' >> /etc/salt/minion_id"
    server.vm.provision "shell", inline: "service salt-minion start"
    server.vm.provision "shell", inline: "crontab -l | fgrep -i -v 'salt-key -A -y' | echo '* * * * * salt-key -A -y' | crontab -"
    server.vm.provision "shell", inline: "yum install httpd -y"
    server.vm.provision "shell", inline: "chkconfig httpd on"
    server.vm.provision "shell", inline: "service httpd start"
    server.vm.provision "shell", inline: "mkdir /srv/pillar/"
    server.vm.provision "shell", inline: "cp /vagrant/pillar.example /srv/pillar/loadbalancer.sls"
    server.vm.provision "shell", inline: "echo 'base:' >> /srv/pillar/top.sls"
    server.vm.provision "shell", inline: "echo \"  '*\':\" >> /srv/pillar/top.sls"
    server.vm.provision "shell", inline: "echo '    - loadbalancer' >> /srv/pillar/top.sls"
    server.vm.provision "shell", inline: "sleep 30"
    server.vm.provision "shell", inline: "salt '*' state.sls loadbalancer"
    server.vm.provision "shell", inline: "service httpd restart"
  end
end
