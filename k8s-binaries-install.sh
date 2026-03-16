#!/bin/bash
# ---------------------------------------------------------
# CKA Lab: Kubernetes Binary Installation (Official Repo)
# ---------------------------------------------------------

# Set to latest stable (e.g., v1.35)
K8S_VERSION=v1.35

echo "📦 Installing Kubernetes $K8S_VERSION..."

# 1. Add Kubernetes GPG Key and Repo
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/$K8S_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$K8S_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# 2. Install Binaries
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# 3. Prevent automatic updates (Critical for Production/CKA)
sudo apt-mark hold kubelet kubeadm kubectl

echo "✅ Kubernetes $K8S_VERSION binaries installed and locked!"