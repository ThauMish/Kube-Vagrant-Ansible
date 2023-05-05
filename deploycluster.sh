#!/bin/bash

# Ask for user input
read -p "Enter the master node IP: " master_ip
read -p "Enter the number of slave nodes: " num_slaves
read -p "Enter the pod network CIDR (e.g. 176.16.0.0/16): " pod_network_cidr
read -p "Enter the starting IP address for slave nodes (e.g., 192.168.31.201): " start_ip

IFS='.' read -ra ADDR <<< "$start_ip"
start_ip_last_octet=${ADDR[3]}
export START_IP_LAST_OCTET=$start_ip_last_octet

escaped_pod_network_cidr=$(echo $pod_network_cidr | sed 's/\//\\\//g')

# Update the Vagrantfile
sed -i "s/ip: \"192.168.31.[0-9]*\"/ip: \"$master_ip\"/" Vagrantfile
sed -i "s/N = [0-9]*/N = $num_slaves/" Vagrantfile

for i in $(seq 1 $num_slaves); do
    ip=$((start_ip_last_octet + i - 1))
    sed -i "s/ip: \"192.168.31.[0-9]*\"/ip: \"192.168.31.${ip}\"/2" Vagrantfile
done

# Update the vars.yml
sed -i "s/k8s_master_ip: \"192.168.31.[0-9]*\"/k8s_master_ip: \"$master_ip\"/" vars.yml
sed -i "s/pod_network_cidr: \"[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\/[0-9]*\"/pod_network_cidr: \"$escaped_pod_network_cidr\"/" vars.yml

echo "Vagrantfile and vars.yml updated successfully."

# Deploy all machines using Vagrant
sudo vagrant up --no-provision --parallel
sudo vagrant up --provision

# Use the generated Ansible inventory file for provisioning
sudo ansible-playbook -i ansible_inventory.ini master-playbook.yml
for i in $(seq 1 $num_slaves); do
    sudo ansible-playbook -i ansible_inventory.ini node-playbook.yml --limit node-$i &
done
wait
