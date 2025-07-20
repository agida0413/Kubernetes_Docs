#!/bin/bash

set -e

echo "===== 1. 시스템 업데이트 및 기본 패키지 설치 ====="
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl

echo "===== 2. Swap 비활성화 ====="
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

echo "===== 3. 커널 설정 (bridge 네트워크용) ====="
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

echo "===== 4. containerd 설치 및 설정 ====="
sudo apt-get install -y containerd

sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

echo "===== 5. Kubernetes 저장소 추가 및 kubeadm, kubelet, kubectl 설치 ====="
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "===== 6. kubeadm 클러스터 초기화 ====="
# 자신의 마스터 노드 IP 주소로 변경 필요 (eth0 대신 환경에 맞게 조정)
MASTER_IP=$(hostname -I | awk '{print $1}')
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=${MASTER_IP}

echo "===== 7. kubectl 환경 설정 ====="
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "===== 8. Pod Network 설치 (Calico 예제) ====="
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

echo "===== 9. 마스터 노드에 파드 스케줄링 허용 (taint 제거) ====="
kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true

echo "===== 설치 완료! kubectl get nodes 로 상태 확인하세요. ====="
