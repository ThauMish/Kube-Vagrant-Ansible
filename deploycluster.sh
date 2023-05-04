#!/bin/bash

# Ask for user input
read -p "Enter the master node IP: " master_ip
read -p "Enter the number of slave nodes: " num_slaves

# Update the Vagrantfile
sed -i "s/ip: \"192.168.31.[0-9]*\"/ip: \"$master_ip\"/" Vagrantfile
sed -i "s/N = [0-9]*/N = $num_slaves/" Vagrantfile
for i in $(seq 1 $num_slaves); do
    ip=$((i + 210))
    sed -i "s/ip: \"192.168.31.[0-9]*\"/ip: \"192.168.31.${ip}\"/2" Vagrantfile
done

# Update the vars.yml
sed -i "s/k8s_master_ip: \"192.168.31.[0-9]*\"/k8s_master_ip: \"$master_ip\"/" vars.yml

echo "Vagrantfile and vars.yml updated successfully."

sudo vagrant up --parallel --no-provision

sudo vagrant provision k8s-master

for i in $(seq 1 $num_slaves); do
    sudo vagrant provision node-$i &
done
wait