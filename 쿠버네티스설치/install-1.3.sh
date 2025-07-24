echo '======== [4] Rocky Linux 기본 설정 ========'
echo '======== [4-1] 타임존 설정 ========'
timedatectl set-timezone Asia/Seoul
timedatectl set-ntp true
chronyc makestep

echo '======== [4-2] [WARNING FileExisting-tc]: tc not found in system path 로그 관련 업데이트 ========'
yum install -y yum-utils iproute-tc
echo '======== [4-2] [WARNING OpenSSL version mismatch 로그 관련 업데이트 ========'
yum update openssl openssh-server -y

echo '======= [4-3] hosts 설정 =========='
cat << EOF >> /etc/hosts
192.168.56.30 k8s-master
192.168.56.31 k8s-worker1
192.168.56.32 k8s-worker2
EOF

echo '======== [5] kubeadm 설치 전 사전작업 ========'
echo '======== [5] 방화벽 해제 ========'
systemctl stop firewalld && systemctl disable firewalld

echo '======== [5] Swap 비활성화 ========'
swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab

echo '======== [6] 컨테이너 런타임 설치 ========'
echo '======== [6-1] 컨테이너 런타임 설치 전 사전작업 ========'
echo '======== [6-1] iptable 세팅 ========'
cat <<EOF |tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF |tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

echo '======== [6-2] 컨테이너 런타임 (containerd 설치) ========'
echo '======== [6-2-1] containerd 패키지 설치 (option2) ========'
echo '======== [6-2-1-1] docker engine 설치 ========'
echo '======== [6-2-1-1] repo 설정 ========'
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo '======== [6-2-1-1] containerd 설치 ========'
yum install -y containerd.io-1.6.32-3.1.el9
systemctl daemon-reload
systemctl enable --now containerd

echo '======== [6-3] 컨테이너 런타임 : cri 활성화 ========'
containerd config default > /etc/containerd/config.toml
sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd

echo '======== [7] kubeadm 설치 ========'
echo '======== [7] repo 설정 ========'
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

echo '======== [7] SELinux 설정 ========'
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

echo '======== [7] kubelet, kubeadm, kubectl 패키지 설치 ========'
yum install -y kubelet-1.30.5-150500.1.1 kubeadm-1.30.5-150500.1.1 --disableexcludes=kubernetes
systemctl enable --now kubelet

echo '======== [8] kubeadm으로 클러스터 생성  ========'
echo '======== [8-1] 클러스터 초기화 (Pod Network 세팅) ========'
kubeadm init --pod-network-cidr=20.96.0.0/16 --apiserver-advertise-address 192.168.56.30

echo '======== [8-2] kubectl 사용 설정 ========'
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

echo '======== [8-3] Pod Network 설치 (calico) ========'
kubectl create -f https://raw.githubusercontent.com/k8s-1pro/install/main/under-thesea/k8s-cluster-1.30/calico-3.28.2/calico.yaml
kubectl create -f https://raw.githubusercontent.com/k8s-1pro/install/main/under-thesea/k8s-cluster-1.30/calico-3.28.2/calico-custom.yaml

echo '======== [9] 쿠버네티스 편의기능 설치 ========'
echo '======== [9-1] kubectl 자동완성 기능 ========'
yum -y install bash-completion
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
source ~/.bashrc

echo '======== [9-2] Dashboard 설치 ========'
echo '======== [9-2-1] Helm 설치 ========'
curl -O https://get.helm.sh/helm-v3.15.4-linux-amd64.tar.gz
tar -zxvf helm-v3.15.4-linux-amd64.tar.gz
mv linux-amd64/helm /usr/bin/helm

echo '======== [9-2-2] Helm-Dashboard설치 ========'
helm repo add k8s-dashboard https://kubernetes.github.io/dashboard
helm pull k8s-dashboard/kubernetes-dashboard --version 7.7.0
tar -xf kubernetes-dashboard-7.7.0.tgz
curl -O https://raw.githubusercontent.com/k8s-1pro/install/main/under-thesea/k8s-cluster-1.30/kubernetes-dashboard-7.7.0/helm-7.7.0/values-custom.yaml
helm upgrade --install kubernetes-dashboard ./kubernetes-dashboard -n kubernetes-dashboard --create-namespace -f ./kubernetes-dashboard/values-custom.yaml

echo '======== [9-2-3] Dashboard Admin 접근 권한 생성 ========'
curl -O https://raw.githubusercontent.com/k8s-1pro/install/main/under-thesea/k8s-cluster-1.30/kubernetes-dashboard-7.7.0/serviceaccount.yaml
curl -O https://raw.githubusercontent.com/k8s-1pro/install/main/under-thesea/k8s-cluster-1.30/kubernetes-dashboard-7.7.0/clusterrolebinding.yaml
curl -O https://raw.githubusercontent.com/k8s-1pro/install/main/under-thesea/k8s-cluster-1.30/kubernetes-dashboard-7.7.0/secret.yaml



1. kubectl 설치안됌 -- > 따로 설치
2. helm 설치안됌 --- > tar install
3. helm arm64버전 불일치 문제
4. 대시보드 설치 이슈 0--- > ./values 경로로
5. 토큰 미발행 문제 - > 마지막에 다운받은 yaml 적용