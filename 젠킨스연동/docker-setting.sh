 Docker 사용 설정


 # jeknins가 Docker를 사용할 수 있도록 권한 부여
 [root@cicd-server ~]# chmod 666 /var/run/docker.sock
 [root@cicd-server ~]# usermod -aG docker jenkins

 # Jeknins로 사용자 변경
 [root@cicd-server ~]# su - jenkins -s /bin/bash

 # 자신의 Dockerhub로 로그인 하기
 [jenkins@cicd-server ~]$ docker login
 Username:
 Password: