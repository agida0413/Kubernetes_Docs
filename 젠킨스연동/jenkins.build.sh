생성된 Jar 파일 확인

[jenkins@cicd-server ~]$ ll /var/lib/jenkins/workspace/2121-source-build/build/libs
-rw-r--r--. 1 jenkins jenkins 19025350 Oct 19 11:19 app-0.0.1-SNAPSHOT.jar
-rw-r--r--. 1 jenkins jenkins    16646 Oct 19 11:19 app-0.0.1-SNAPSHOT-plain.jar



Build Steps > Execute shell

# jar 파일 복사
cp /var/lib/jenkins/workspace/2121-source-build/build/libs/app-0.0.1-SNAPSHOT.jar ./2121/build/docker/app-0.0.1-SNAPSHOT.jar

# 도커 빌드
docker build -t <DockerHub_Username>/api-tester:v1.0.0 ./2121/build/docker
docker push <DockerHub_Username>/api-tester:v1.0.0