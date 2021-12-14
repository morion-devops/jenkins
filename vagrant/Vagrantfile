Vagrant.configure("2") do |config|

  config.vm.define "jenkins-master" do |server|
    server.vm.box = "debian/bullseye64"
    server.vm.hostname = "jenkins-master"
    server.vm.network "private_network", ip: "192.168.121.102"
    server.vm.synced_folder '.', '/vagrant', disabled: true # disable default binding

    server.vm.provider :libvirt do |domain|
      domain.memory = 800
      domain.cpus = 1
    end

  end

  # ------------------------------
  # node1 (docker-builder)
  # ------------------------------
  config.vm.define "jenkins-node1" do |server|
    server.vm.box = "debian/bullseye64"
    server.vm.hostname = "jenkins-node1"
    server.vm.network "private_network", ip: "192.168.121.101"
    server.vm.synced_folder '.', '/vagrant', disabled: true # disable default binding

    server.vm.provider :libvirt do |domain|
      domain.memory = 600
      domain.cpus = 1
    end

  end
end