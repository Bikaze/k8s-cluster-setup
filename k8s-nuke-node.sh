#!/bin/bash
# ---------------------------------------------------------
# CKA Lab: The "Nuke" Script (Complete Reset). First on the worker node, then on the control plane if needed.
# ---------------------------------------------------------

echo "⚠️  Destroying Kubernetes state on this node..."

# 1. The official reset
sudo kubeadm reset -f

# 2. Cleanup networking artifacts (The "Silent Killers")
sudo rm -rf /etc/cni/net.d
sudo rm -rf /opt/cni/bin
sudo ip link delete cni0 2>/dev/null
sudo ip link delete flannel.1 2>/dev/null
sudo ip link delete cali0 2>/dev/null

# 3. Flush the Iptables (The most important step)
echo "🧹 Flushing iptables..."
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X

# 4. Cleanup local user config
rm -rf $HOME/.kube

# 5. Restart the runtime to clear any hung containers
sudo systemctl restart containerd

echo "✅ Node is now a clean slate. Ready for a new 'init' or 'join'!"