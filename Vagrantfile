IMAGE_NAME = "bento/ubuntu-20.04"
N = 0
MASTER_IP = "192.168.31.200"
PUBLIC_KEY = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDkS70kWyusQ+SE/xH0dOuAV4w76OsI0r4vp2ZxVSVwLZ3cg+qOFGYn3t6Mg2ZNbSiTMnxMA2mRlpbJINwwPwCR2AyOyYnR+knZoHFFRD58eos2fsDPe1qiMzvFRr9z5fNMzdbNdo01azG+oEOfDzCNUBYS8pM3Xt+TfXDBLj7v2NjxOYDpuTXexrEfvofcPhEoSFQqp5S8uxIBB952c5Y+3ieVgn2GnBG/aOIppa8vYhZWRgzKRA+C/K0tmm7DPm1prcCRbNm1kMyHqH1015NJB8NZbXO2X9GT6hJgwLBv6fv80RV+a107hK0ALPMVvrzIzE5TwQO5uitjW70lgZ/wuyxDPsRjXiZiLY17JGLa6oyvsr0VNxtednDLkHxBsANq0Quay49vYFIHaDn5CvtsVhdyDhXqr/4REjMTmC9TA1VwdQJoPUB/iLnyxzk2bUVgW95oGlrZsBk8dXXmbuNlM9dLWC7H/jX7QVCBFiqouyhugFyvtlLLB49poh51o8aczTm6MytCDCVZoQNmbiTuVtJdGvpaQcMjtVSCQadexKl0m8cbfL49k6ZL2YKgWuoOhn97fxvJR1KARjTtPK1e9r1JiFJycGvdvFpXzcub4qY7MrVtvJ8ll2H+IKBY67Yk3pKzuKBayb/x0Ve42Egyu6KyBvn1clDcsH8GLc76QQ== k8s_vagrant"

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false
    config.ssh.private_key_path = ["~/.ssh/id_rsa_k8s_vagrant", "~/.vagrant.d/insecure_private_key"]

    config.vm.define "k8s-master" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "public_network", bridge: "enp59s0", ip: MASTER_IP
        master.vm.hostname = "k8s-master"
        master.vm.provider "virtualbox" do |v|
            v.memory = 4096
            v.cpus = 2
        end
        master.vm.provision "shell", inline: <<-SHELL
            echo '#ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDkS70kWyusQ+SE/xH0dOuAV4w76OsI0r4vp2ZxVSVwLZ3cg+qOFGYn3t6Mg2ZNbSiTMnxMA2mRlpbJINwwPwCR2AyOyYnR+knZoHFFRD58eos2fsDPe1qiMzvFRr9z5fNMzdbNdo01azG+oEOfDzCNUBYS8pM3Xt+TfXDBLj7v2NjxOYDpuTXexrEfvofcPhEoSFQqp5S8uxIBB952c5Y+3ieVgn2GnBG/aOIppa8vYhZWRgzKRA+C/K0tmm7DPm1prcCRbNm1kMyHqH1015NJB8NZbXO2X9GT6hJgwLBv6fv80RV+a107hK0ALPMVvrzIzE5TwQO5uitjW70lgZ/wuyxDPsRjXiZiLY17JGLa6oyvsr0VNxtednDLkHxBsANq0Quay49vYFIHaDn5CvtsVhdyDhXqr/4REjMTmC9TA1VwdQJoPUB/iLnyxzk2bUVgW95oGlrZsBk8dXXmbuNlM9dLWC7H/jX7QVCBFiqouyhugFyvtlLLB49poh51o8aczTm6MytCDCVZoQNmbiTuVtJdGvpaQcMjtVSCQadexKl0m8cbfL49k6ZL2YKgWuoOhn97fxvJR1KARjTtPK1e9r1JiFJycGvdvFpXzcub4qY7MrVtvJ8ll2H+IKBY67Yk3pKzuKBayb/x0Ve42Egyu6KyBvn1clDcsH8GLc76QQ== k8s_vagrant' >> /home/vagrant/.ssh/authorized_keys
            chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
            chmod 600 /home/vagrant/.ssh/authorized_keys
        SHELL
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "public_network", bridge: "enp59s0", ip: "192.168.31.#{201 + i}"
            node.vm.hostname = "node-#{i}"
            node.vm.provider "virtualbox" do |v|
                v.memory = 2048
                v.cpus = 2
            end
            node.vm.provision "shell", inline: <<-SHELL
                echo '#ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDkS70kWyusQ+SE/xH0dOuAV4w76OsI0r4vp2ZxVSVwLZ3cg+qOFGYn3t6Mg2ZNbSiTMnxMA2mRlpbJINwwPwCR2AyOyYnR+knZoHFFRD58eos2fsDPe1qiMzvFRr9z5fNMzdbNdo01azG+oEOfDzCNUBYS8pM3Xt+TfXDBLj7v2NjxOYDpuTXexrEfvofcPhEoSFQqp5S8uxIBB952c5Y+3ieVgn2GnBG/aOIppa8vYhZWRgzKRA+C/K0tmm7DPm1prcCRbNm1kMyHqH1015NJB8NZbXO2X9GT6hJgwLBv6fv80RV+a107hK0ALPMVvrzIzE5TwQO5uitjW70lgZ/wuyxDPsRjXiZiLY17JGLa6oyvsr0VNxtednDLkHxBsANq0Quay49vYFIHaDn5CvtsVhdyDhXqr/4REjMTmC9TA1VwdQJoPUB/iLnyxzk2bUVgW95oGlrZsBk8dXXmbuNlM9dLWC7H/jX7QVCBFiqouyhugFyvtlLLB49poh51o8aczTm6MytCDCVZoQNmbiTuVtJdGvpaQcMjtVSCQadexKl0m8cbfL49k6ZL2YKgWuoOhn97fxvJR1KARjTtPK1e9r1JiFJycGvdvFpXzcub4qY7MrVtvJ8ll2H+IKBY67Yk3pKzuKBayb/x0Ve42Egyu6KyBvn1clDcsH8GLc76QQ== k8s_vagrant' >> /home/vagrant/.ssh/authorized_keys
                chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
                chmod 600 /home/vagrant/.ssh/authorized_keys
            SHELL
        end
    end
end
