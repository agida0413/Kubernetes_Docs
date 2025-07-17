echo '======== [1] Rocky Linux 기본 설정 ========'
echo '======== [1-1] 패키지 업데이트 ========'
# 강의와 동일한 실습 환경을 유지하기 위해 Linux Update는 하지 마세요!
# yum -y update # (x)

echo '======== [1-2] 타임존 설정 ========'
timedatectl set-timezone Asia/Seoul

echo '======== [1-3] 방화벽 해제 ========'
systemctl stop firewalld && systemctl disable firewalld


echo '======== [2] Kubectl 설치 ========'
echo '======== [2-1] repo 설정 ========'
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.27/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.27/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

echo '======== [2-2] Kubectl 설치 ========'
yum install -y kubectl-1.27.2-150500.1.1.aarch64 --disableexcludes=kubernetes


echo '======== [3] 도커 설치 ========'
# https://download.docker.com/linux/centos/8/x86_64/stable/Packages/ 저장소 경로
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce-3:23.0.6-1.el9.aarch64 docker-ce-cli-1:23.0.6-1.el9.aarch64 containerd.io-1.6.21-3.1.el9.aarch64
systemctl daemon-reload
systemctl enable --now docker

echo '======== [4] OpenJDK 설치  ========'
yum install -y java-17-openjdk

echo '======== [5] Gradle 설치  ========'
yum -y install wget unzip
wget https://services.gradle.org/distributions/gradle-7.6.1-bin.zip -P ~/
unzip -d /opt/gradle ~/gradle-*.zip
cat <<EOF |tee /etc/profile.d/gradle.sh
export GRADLE_HOME=/opt/gradle/gradle-7.6.1
export PATH=/opt/gradle/gradle-7.6.1/bin:${PATH}
EOF
chmod +x /etc/profile.d/gradle.sh
source /etc/profile.d/gradle.sh

echo '======== [6] Git 설치  ========'
# 기존엔 git-2.43.0-1.el8 버전을 Fix하였으나 Repository에 최신 버전만 업로드 됨으로 수정
yum install -y git

echo '======== [7] Jenkins 설치  ========'
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y jenkins-2.504.3-1.1
systemctl enable jenkins
systemctl start jenkins

# Jenkns 설치 후 OpenSSL 최신 버전으로 업데이트
yum update -y openssh-server openssh-clients openssl openssl-libs
systemctl restart sshd