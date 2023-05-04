#!/bin/bash

# Ask for master node IP
read -p "Enter the master node IP: " master_ip

# Ask for the number of slave nodes
read -p "Enter the number of slave nodes: " num_slaves

# Ask for the starting IP address for slave nodes
read -p "Enter the starting IP address for slave nodes (e.g., 192.168.31.201): " start_ip
IFS='.' read -ra start_ip_parts <<< "$start_ip"

# Update Vagrantfile
sed -i "s/\(config.ssh.insert_key = \)false/\1true/" Vagrantfile
sed -i "s/\(master.vm.network \"public_network\", bridge: \"enp59s0\", ip: \)\"192.168.31.200\"/\1\"$master_ip\"/" Vagrantfile
sed -i "s/\(N = \)2/\1$num_slaves/" Vagrantfile
sed -i "s/\(node.vm.network \"public_network\", bridge: \"enp59s0\", ip: \)\"192.168.31.#{i + 210}\"/\1\"192.168.31.#{i + ${start_ip_parts[-1]}}\"/" Vagrantfile

# Update vars.yml
sed -i "s/\(k8s_master_ip: \)\"192.168.31.200\"/\1\"$master_ip\"/" vars.yml

echo "Vagrantfile and vars.yml updated successfully."

sudo vagrant up --parallel
