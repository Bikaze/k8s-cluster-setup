#!/bin/bash
# ---------------------------------------------------------
# CKA Lab: Cluster Initialization (Control Plane)
# ---------------------------------------------------------

# Replace with your actual VM IP from 'ip addr'
CP_IP="INPUT_CONTROL_PLANE_IP_HERE"
POD_CIDR="192.168.0.0/16"

echo "☸️ Initializing Cluster on $CP_IP..."

sudo kubeadm init --pod-network-cidr=$POD_CIDR --apiserver-advertise-address=$CP_IP

# Setup Local Kubectl Config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico CNI
echo "🌐 Installing Calico Network Plugin..."
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml

echo "✅ Cluster initialized! Check status with 'kubectl get nodes -w'"