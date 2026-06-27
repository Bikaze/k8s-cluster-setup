#!/bin/bash
# ---------------------------------------------------------
# CKA Lab: Kubernetes Binary Installation (Official Repo)
# ---------------------------------------------------------

set -e # Halt script instantly if any single command fails!

# Enforce the minor version string precisely for the pkgs URL directory path
K8S_MINOR="v1.35"
# Target the exact frozen patch version string you want apt to install
K8S_PATCH="1.35.0-1.1" 

echo "📦 Configuring official repository for Kubernetes $K8S_MINOR..."

# 1. Add Kubernetes GPG Key and Repo directly from pkgs.k8s.io
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sudo mkdir -p -m 755 /etc/apt/keyrings

# Safely download the matching minor release key
curl -fsSL "https://pkgs.k8s.io/core:/stable:/${K8S_MINOR}/deb/Release.key" | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Register the matching minor package distribution stream
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${K8S_MINOR}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# 2. Install Binaries matching your frozen test patch
sudo apt-get update
echo "📥 Installing patch version: $K8S_PATCH..."
sudo apt-get install -y kubelet=$K8S_PATCH kubeadm=$K8S_PATCH kubectl=$K8S_PATCH

# 3. Prevent automatic version drift
sudo apt-mark hold kubelet kubeadm kubectl

echo "✅ Official Kubernetes components successfully installed and locked!"
