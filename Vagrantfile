IMAGE_NAME = "bento/ubuntu-20.04"
N = 3

Vagrant.configure("2") do |config|
    config.ssh.insert_key = true

    config.vm.define "k8s-master" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "public_network", bridge: "enp59s0", ip: "192.168.31.200"
        master.vm.hostname = "k8s-master"
        master.vm.provider "virtualbox" do |v|
            v.memory = 4096
            v.cpus = 2
        end
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "master-playbook.yml"
            ansible.extra_vars = {
                node_ip: "192.168.31.200",
            }
        end
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "public_network", bridge: "enp59s0", ip: "192.168.31.#{i + 201}"
            node.vm.hostname = "node-#{i}"
            node.vm.provider "virtualbox" do |v|
                v.memory = 2048
                v.cpus = 2
            end
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "node-playbook.yml"
                ansible.extra_vars = {
                    node_ip: "192.168.31.#{i + 210}",
                }
            end
        end
    end
end
