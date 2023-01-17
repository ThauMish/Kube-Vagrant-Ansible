# Kube-Vagrant-Ansible

+ This GitHub repository contains an Ansible playbook to deploy a Kubernetes infrastructure on virtual machines managed by Vagrant. It uses Ubuntu 18.04 LTS as its basic operating system and uses Docker and containerd.io to manage containers.

+ `- Ansible : 2.9.x`
+ `- Ubuntu : 18.04 LTS`
+ `- Docker : 19.03.x`
+ `- containerd.io : 1.3.x`
+ `- Kubernetes : 1.26.0`
+ `- kubelet : 1.26.0-00`
+ `- kubeadm : 1.26.0-00`
+ `- kubectl : 1.26.0-00`
+ `- calico : 3.25`

## Prérequis

+ To use this repository, you must have:
* - Vagrant
* - VirtualBox
* - Ansible

## Usage

* 1. Clone the repository
* 2. Run `vagrant up` to start the virtual machine
* 3. Run `vagrant ssh` to log in to the virtual machine
* 4. Run `kubectl get nodes` to verify that the Kubernetes cluster is up and running

## Provisioning
* The provisioning process is handled by Ansible playbooks. These playbooks will install the necessary packages and configure the virtual machine to run as a Kubernetes node.

## Cleanup
* To stop and delete the virtual machine, run `vagrant destroy`



