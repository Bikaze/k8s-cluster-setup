# Kubernetes Cluster Setup Scripts

A compact toolkit to bootstrap, initialize, and reset a Kubernetes cluster for lab or learning environments.

## 🧩 Sticker Board

- 🛠️ **Goal:** Fast, repeatable Kubernetes setup
- 🐧 **OS:** Ubuntu/Debian-based nodes (uses `apt`)
- ⚙️ **Runtime:** containerd
- 🌐 **CNI:** Calico
- 🧹 **Reset:** Full cleanup script included

## 🚀 Quick Flow

Run scripts in this order:

1. `k8s-node-prep.sh` (all nodes)
2. `k8s-binaries-install.sh` (all nodes)
3. `k8s-cluster-init.sh` (control plane only)
4. `setup-k8s-alias.sh` (optional, your shell)
5. `install-calico.sh` (optional alternative to Calico step in init script)

If you need to start over on a node: `k8s-nuke-node.sh`

## 📦 What Each Script Does

### `k8s-node-prep.sh`
Prepares a Linux node for Kubernetes:
- Disables swap permanently
- Loads required kernel modules (`overlay`, `br_netfilter`)
- Applies sysctl networking settings
- Installs and configures `containerd`
- Enables `SystemdCgroup=true` and restarts runtime

### `k8s-binaries-install.sh`
Installs Kubernetes binaries from the official repo:
- Adds Kubernetes apt repository and GPG key
- Installs `kubelet`, `kubeadm`, `kubectl`
- Holds package versions to prevent unintended upgrades

### `k8s-cluster-init.sh`
Initializes the control plane:
- Runs `kubeadm init` with pod CIDR
- Configures local `kubectl` access (`~/.kube/config`)
- Installs Calico manifests

⚠️ Edit `CP_IP` before running.

### `install-calico.sh`
One-liner Calico install for the control plane:
- Applies `tigera-operator`
- Applies Calico custom resources

Use this if you want to install Calico separately from init.

### `setup-k8s-alias.sh`
Improves CLI experience:
- Installs bash completion
- Adds `k` alias for `kubectl`
- Enables command autocompletion

### `k8s-nuke-node.sh`
Performs a full node reset:
- Runs `kubeadm reset -f`
- Removes CNI artifacts
- Flushes iptables
- Clears local kube config
- Restarts containerd

## ✅ Example Usage

```bash
chmod +x *.sh

# On every node
./k8s-node-prep.sh
./k8s-binaries-install.sh

# On control plane
# (edit CP_IP in k8s-cluster-init.sh first)
./k8s-cluster-init.sh

# Optional shell helpers
./setup-k8s-alias.sh
```

## 🧠 Notes

- The scripts target training/lab workflows; review before production use.
- Keep Kubernetes and Calico versions aligned with your environment.
- For workers, use the `kubeadm join ...` command produced by `kubeadm init`.
