CI/CD 서버에서 초기 비밀번호 확인

cat /var/lib/jenkins/secrets/initialAdminPassword

본인의 JDK17 설치 경로 확인

[root@cicd-server ~]# find / -name java | grep java-17-openjdk
/usr/lib/jvm/java-17-openjdk-17.0.9.0.9-2.el9.aarch64/bin/java  // -->> /bin/java 제외하고 복사

Gradle 세팅
# Name : gradle-7.6.1
# GRADLE_HOME : /opt/gradle/gradle-7.6.1
