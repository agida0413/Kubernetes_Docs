▶ NFS 패키지 설치

yum -y install nfs-utils rpcbind
systemctl start rpcbind
systemctl start nfs-server
systemctl start rpc-statd
systemctl enable rpcbind
systemctl enable nfs-server

// 상태 확인
systemctl status nfs-server

▶ 폴더(Volume) 생성 및 exports 파일 설정

// 폴더 생성
mkdir /file-storage

// exports 파일 설정
vi /etc/exports
--- vi 편집기 ---
/file-storage *(rw,sync,no_root_squash)
----------------

// 설정 반영
exportfs -r
// 재시작
systemctl restart nfs-server

▶ Prometheus, Grafanan용 폴더 생성

cd /file-storage && mkdir monitoring
mkdir monitoring/prometheus && mkdir monitoring/grafana
chmod 777 -R monitoring
