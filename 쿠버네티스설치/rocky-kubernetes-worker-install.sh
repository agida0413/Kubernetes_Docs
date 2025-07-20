echo '======== [1] 기본 설정 ========'
timedatectl set-timezone Asia/Seoul
timedatectl set-ntp true
chronyc makestep

echo '======== [2] 방화벽 해제 및 swap 비활성화 ========'
systemctl stop firewalld && systemctl disable firewalld
swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab

echo '======== [3] 커널 파라미터 및 모듈 설정 ========'
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

echo '======== [4] containerd 설치 ========'
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y containerd.io-1.6.21-3.1.el9.aarch64
systemctl daemon-reload
systemctl enable --now containerd

echo '======== [5] containerd 설정 ========'
containerd config default > /etc/containerd/config.toml
sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd

echo '======== [6] Kubernetes 패키지 설치 ========'
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.27/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.27/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y kubelet-1.27.2-150500.1.1.aarch64 kubeadm-1.27.2-150500.1.1.aarch64 --disableexcludes=kubernetes
systemctl enable --now kubelet

echo '======== [7] 클러스터에 워커노드 조인 준비 완료! ========'
echo '→ 마스터 노드에서 아래 명령어를 확인하세요:'
echo '   kubeadm token create --print-join-command'
echo '→ 그 명령어를 워커 노드에 붙여넣어 실행하면 조인됩니다.'
echo '예시 kubeadm join 192.168.56.30:6443 --token abcdef.0123456789abcdef \
          --discovery-token-ca-cert-hash sha256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'


