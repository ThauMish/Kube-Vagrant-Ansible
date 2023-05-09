## Kubernetes Cluster Deployment with Vagrant and Ansible

This repository provides an automated way to deploy a Kubernetes cluster using Vagrant and Ansible. It creates a master node and a specified number of worker nodes, configures the Kubernetes cluster, and sets up secure SSH access.

## Prerequisites

Before using this script, ensure you have the following software installed:

-   [Vagrant](https://www.vagrantup.com/downloads.html)
-   [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
-   [Python](https://www.python.org/downloads/)
-   [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## How it works

The Python script (`deploy_k8s.py`) reads the `Vagrantfile_template` and `ansible_inventory.ini_template` files and generates a `Vagrantfile` and `ansible_inventory.ini` with the specified parameters. It creates a Kubernetes master node and worker nodes with unique IP addresses and deploys the Kubernetes cluster using Ansible playbooks.

The `Vagrantfile_template` contains placeholders for the master node's IP address, the number of worker nodes, and the public key for SSH authentication. The `ansible_inventory.ini_template` contains placeholders for the IP addresses of the master and worker nodes.

The script generates an SSH key pair if it does not exist and automatically adds the public key to the `authorized_keys` file on each node. This allows for passwordless authentication when connecting via SSH.

## Usage

1.  Clone the repository:
    
    ```bash
    git clone https://github.com/username/Kube-Vagrant-Ansible.git
    cd Kube-Vagrant-Ansible
    ```
    
2.  Run the `deploy_k8s.py` script with the desired options:
    
    ```bash
    python deploy_k8s.py -m 192.168.31.200 -n 2 -b 192.168.31.201
    
    ```
    
    This example deploys a Kubernetes cluster with a master node at IP address `192.168.31.200`, two worker nodes, and worker node IP addresses starting from `192.168.31.201`.
    
    The available options are:
    
    -   `-m` or `--master-ip`: The IP address for the master node (default: `192.168.31.200`).
    -   `-n` or `--num-nodes`: The number of worker nodes (default: `2`).
    -   `-b` or `--base-ip`: The base IP address for worker nodes (default: `192.168.31.201`).
3.  Wait for the deployment to complete. The script will set up the nodes and configure the Kubernetes cluster using Ansible.
    
4.  Access the nodes using SSH with the generated key pair:
    
    ```bash
    ssh -i ~/.ssh/id_rsa_k8s_vagrant vagrant@192.168.31.200
    
    ```
    
    Replace `192.168.31.200` with the IP address of the node you want to access.
    

## Customization

You can modify the `Vagrantfile_template` and `ansible_inventory.ini_template` to customize the deployment. For example, you can change the memory and CPU settings for the nodes, or adjust the network settings.

Always make sure to update the Python script if you modify the templates or add new placeholders.

