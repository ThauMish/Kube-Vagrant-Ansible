import os
import sys
import subprocess
import argparse
from ipaddress import ip_address

def generate_ssh_key_pair():
    key_file = os.path.expanduser('~/.ssh/id_rsa_k8s_vagrant')
    if not os.path.exists(key_file):
        subprocess.run(['ssh-keygen', '-t', 'rsa', '-b', '4096', '-C', 'k8s_vagrant', '-f', key_file, '-q', '-N', ''])
    with open(f"{key_file}.pub", "r") as f:
        public_key = f.read().strip()
    return public_key

def parse_args():
    parser = argparse.ArgumentParser(description="Deploy Kubernetes cluster with Vagrant and Ansible")
    parser.add_argument('-m', '--master-ip', default="192.168.31.200", help="Master node IP address")
    parser.add_argument('-n', '--num-nodes', type=int, default=2, help="Number of worker nodes")
    parser.add_argument('-b', '--base-ip', default="192.168.31.201", help="Base IP for worker nodes")
    return parser.parse_args()

args = parse_args()

MASTER_IP = args.master_ip
IMAGE_NAME = "bento/ubuntu-20.04"
N = args.num_nodes
BASE_IP = args.base_ip

public_key = generate_ssh_key_pair()

# Read Vagrantfile template
with open('Vagrantfile_template', 'r') as f:
    vagrantfile_template = f.read()

# Read ansible_inventory.ini template
with open('ansible_inventory.ini_template', 'r') as f:
    ansible_inventory_template = f.read()

# Generate Vagrantfile
vagrantfile = vagrantfile_template.format(IMAGE_NAME=IMAGE_NAME, MASTER_IP=MASTER_IP, N=N, PUBLIC_KEY=public_key)

# Write Vagrantfile
with open('Vagrantfile', 'w') as f:
    f.write(vagrantfile)

# Generate ansible_inventory.ini
base_ip = ip_address(BASE_IP)
nodes_ips = [str(base_ip + i) for i in range(N)]
ansible_inventory = ansible_inventory_template.format(MASTER_IP=MASTER_IP, NODES_IPS="\n".join(nodes_ips))

# Write ansible_inventory.ini
with open('ansible_inventory.ini', 'w') as f:
    f.write(ansible_inventory)

# Run Vagrant
subprocess.run(["vagrant", "up"])

# Execute Ansible playbooks
subprocess.run(["ansible-playbook", "-i", "ansible_inventory.ini", "--private-key", "~/.ssh/id_rsa_k8s_vagrant", "master-playbook.yml", "--limit", "k8s-master-group"])
subprocess.run(["ansible-playbook", "-i", "ansible_inventory.ini", "--private-key", "~/.ssh/id_rsa_k8s_vagrant", "node-playbook.yml", "--limit", "k8s-nodes"])