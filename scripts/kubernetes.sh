#!/bin/bash

set -e

# -----------------------
# Install K3s
# -----------------------
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644" sh -

# -----------------------
# Setup kubeconfig for user
# -----------------------
mkdir -p ~/.kube

sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
chmod 600 ~/.kube/config

# IMPORTANT: use local config always
export KUBECONFIG=~/.kube/config

# Fix server IP (important for Vagrant multi-node access)
sudo sed -i 's/127.0.0.1/192.168.56.10/g' ~/.kube/config

# -----------------------
# Verify cluster (NOW it will work)
# -----------------------
kubectl get nodes
kubectl get svc

# -----------------------
# Registry config for K3s
# -----------------------
sudo mkdir -p /etc/rancher/k3s

sudo tee /etc/rancher/k3s/registries.yaml > /dev/null <<EOF
mirrors:
  "localhost:5000":
    endpoint:
      - "http://192.168.56.15:5000"
EOF

# -----------------------
# Docker insecure registry
# -----------------------
sudo mkdir -p /etc/docker

sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "insecure-registries": [
    "192.168.56.15:5000"
  ]
}
EOF

# Restart docker safely
sudo systemctl restart docker || true

echo "✅ K3s setup completed successfully"