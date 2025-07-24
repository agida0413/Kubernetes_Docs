[root@k8s-master ~]# yum -y install git

# 로컬 저장소 생성
git init monitoring
git config --global init.defaultBranch main
cd monitoring

# remote 추가 ([root@k8s-master monitoring]#)
git remote add -f origin https://github.com/k8s-1pro/install.git

# sparse checkout 설정
git config core.sparseCheckout true
echo "ground/k8s-1.27/prometheus-2.44.0" >> .git/info/sparse-checkout
echo "ground/k8s-1.27/loki-stack-2.6.1" >> .git/info/sparse-checkout

# 다운로드
git pull origin main