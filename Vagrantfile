IMAGE_NAME = "bento/ubuntu-20.04"
N = 1

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
            ansible.playbook = "dummy.yml"
            ansible.inventory_path = "ansible_inventory.ini"
        end
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
    node.vm.network "public_network", bridge: "enp59s0", ip: "192.168.31.#{ENV['START_IP_LAST_OCTET'].to_i + i}"
            node.vm.hostname = "node-#{i}"
            node.vm.provider "virtualbox" do |v|
                v.memory = 2048
                v.cpus = 2
            end
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "dummy.yml"
                ansible.inventory_path = "ansible_inventory.ini"
            end
        end
    end

    config.vm.provision "shell", run: "always", inline: <<-SHELL
    echo "[k8s-master-group]" > /vagrant/ansible_inventory.ini
    echo "k8s-master ansible_host=192.168.31.200 ansible_user=vagrant" >> /vagrant/ansible_inventory.ini
    echo "" >> /vagrant/ansible_inventory.ini
    echo "[k8s-nodes]" >> /vagrant/ansible_inventory.ini
    for i in $(seq 1 #{N}); do
      echo "node-${i} ansible_host=192.168.31.$((START_IP_LAST_OCTET + i - 1)) ansible_user=vagrant" >> /vagrant/ansible_inventory.ini
    done
SHELL
  
end
