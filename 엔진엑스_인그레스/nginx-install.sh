 Mac (m 시리즈)
[root@k8s-master ~]#
yum install -y tar
curl -O https://get.helm.sh/helm-v3.13.2-linux-arm64.tar.gz
tar -zxvf helm-v3.13.2-linux-arm64.tar.gz
mv linux-arm64/helm /usr/bin/helm


 Nginx 다운로드 및 배포
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm pull ingress-nginx/ingress-nginx --version 4.10.0

# 압축 해제
tar -xf ingress-nginx-4.10.0.tgz

# 배포
cd ingress-nginx
curl -O https://raw.githubusercontent.com/k8s-1pro/install/main/ground/cicd-server/nginx/helm/ingress-nginx/values-dev.yaml
helm upgrade ingress-nginx . -f ./values-dev.yaml -n ingress-nginx --install --create-namespace




https://cafe.naver.com/kubeops/231