# CI/CD Server에서 helm 설치 (root 유저)

yum install -y tar
curl -O https://get.helm.sh/helm-v3.13.2-linux-arm64.tar.gz
tar -zxvf helm-v3.13.2-linux-arm64.tar.gz
mv linux-arm64/helm /usr/bin/helm

#확인하기
# jenkins 유저로 전환해서 확인
[root@cicd-server ~]# su - jenkins -s /bin/bash
[jenkins@cicd-server ~]$ helm



# helm 템플릿 생성
[jenkins@cicd-server ~]$ helm create api-tester
[jenkins@cicd-server ~]$ cd api-tester
[jenkins@cicd-server api-tester]$ ls
charts  Chart.yaml  templates  values.yaml



https://cafe.naver.com/kubeops/98


---------------
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
