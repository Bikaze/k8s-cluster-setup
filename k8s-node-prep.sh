#!/bin/bash
# ---------------------------------------------------------
# CKA Lab: Node Preparation (Official Containerd Repo)
# ---------------------------------------------------------

# 1. Permanent Swap Disable
sudo swapoff -a
sudo sed -i.bak '/swap/s/^/#/' /etc/fstab

# 2. Kernel Modules (Overlay & Networking)
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# 3. Networking Parameters (IPv4 Forwarding & Bridges)
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system

# 4. Install Latest containerd.io from Docker Official Repo
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y containerd.io

# 5. Generate & Configure Default Config
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null

# Set SystemdCgroup to true and update Sandbox image to 3.10
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo sed -i 's|registry.k8s.io/pause:3.8|registry.k8s.io/pause:3.10.1|g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

echo "✅ Container Runtime (containerd.io) installed and configured!"