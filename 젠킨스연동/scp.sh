 Master Node에서 인증서 복사


CI/CD 서버에서 SCP 명령으로 인증서 가져오기

# 폴더 생성
[jenkins@cicd-server ~]$ mkdir ~/.kube

# Master Node에서 인증서 가져오기
[jenkins@cicd-server ~]$ scp root@192.168.56.30:/root/.kube/config ~/.kube/
