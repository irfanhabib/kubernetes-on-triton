#!/bin/bash

set -ex


sudo bash -c 'ulimit -l unlimited && \
ulimit -n 100000 && \
echo "1024 65535" > /proc/sys/net/ipv4/ip_local_port_range && \
echo 5 > /proc/sys/net/ipv4/tcp_fin_timeout && \
echo 0 > /proc/sys/net/ipv4/tcp_tw_recycle && \
echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse && \
echo 1024 > /proc/sys/net/core/somaxconn'

sudo apt-get update


# Setup an interface for SCF
sudo ip addr add 192.168.77.77/24 brd + dev net1 label net1:0

# Install Docker
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce

 # Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Install Kubelet and KubeADM

sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo bash -c 'cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF'
sudo apt-get update
sudo apt-get install -y kubelet kubeadm


echo "Before init..."

# Setup cluster
kubeadm init --pod-network-cidr=10.244.0.0/16 &

sleep 150
echo "Done waiting..."
# Configure kubectl
mkdir -p /home/ubuntu/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# Make the user own it `ubuntu:ubuntu`
sudo chown 1000:1000 $HOME/.kube/config

# Setup Flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-rbac.yml

# Remove taint from master node
kubectl taint nodes --all node-role.kubernetes.io/master-

# Install Dashboard
kubectl create -f https://git.io/kube-dashboard-no-rbac
