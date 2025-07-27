helm upgrade --install mysql-userdb bitnami/mysql \
  --namespace backend-app-db \
  --set architecture=replication \
  --set auth.rootPassword=kim1234 \
  --set auth.username=admin \
  --set auth.password=kim1234 \
  --set auth.database=usersv \
  --set replication.password=replica1234 \
  --set primary.persistence.enabled=true \
  --set primary.persistence.storageClass=local-path \
  --set primary.persistence.size=10Mi \
  --set secondary.persistence.enabled=true \
  --set secondary.persistence.storageClass=local-path \
  --set secondary.persistence.size=10Mi \
  --set service.type=NodePort \
  --set service.nodePort=30306 \
  --set primary.resources.requests.cpu=10m \
  --set primary.resources.requests.memory=10Mi \
  --set secondary.resources.requests.cpu=10m \
  --set secondary.resources.requests.memory=10Mi

helm upgrade --install mysql-orderdb bitnami/mysql \
  --namespace backend-app-db \
  --set architecture=replication \
  --set auth.rootPassword=kim1234 \
  --set auth.username=admin \
  --set auth.password=kim1234 \
  --set auth.database=ordersv \
  --set replication.password=replica1234 \
  --set primary.persistence.enabled=true \
  --set primary.persistence.storageClass=local-path \
  --set primary.persistence.size=10Mi \
  --set secondary.persistence.enabled=true \
  --set secondary.persistence.storageClass=local-path \
  --set secondary.persistence.size=10Mi \
  --set service.type=NodePort \
  --set service.nodePort=30307\
  --set primary.resources.requests.cpu=10m \
  --set primary.resources.requests.memory=10Mi \
  --set secondary.resources.requests.cpu=10m \
  --set secondary.resources.requests.memory=10Mi

  //단일인스턴스
  helm install mysql-userdb bitnami/mysql \
    --namespace backend-app \
    --set architecture=standalone \
    --set auth.rootPassword=kim1234 \
    --set auth.username=admin \
    --set auth.password=kim1234 \
    --set auth.database=usersv \
    --set primary.persistence.enabled=true \
    --set primary.persistence.storageClass=local-path \
    --set primary.persistence.size=1Gi



helm uninstall mysql-userdb -n backend-app-db


helm uninstall mysql-orderdb -n backend-app-db



  //단일인스턴스
  helm install mysql-userdb bitnami/mysql \
    --namespace backend-app-db \
    --set architecture=standalone \
    --set auth.rootPassword=kim1234 \
    --set auth.username=admin \
    --set auth.password=kim1234 \
    --set auth.database=usersv \
    --set primary.persistence.enabled=true \
    --set primary.persistence.storageClass=longhorn \
    --set primary.persistence.size=100Mi
    --set service.type=NodePort

  //단일인스턴스
  helm install mysql-orderdb bitnami/mysql \
    --namespace backend-app-db \
    --set architecture=standalone \
    --set auth.rootPassword=kim1234 \
    --set auth.username=admin \
    --set auth.password=kim1234 \
    --set auth.database=ordersv \
    --set primary.persistence.enabled=true \
    --set primary.persistence.storageClass=longhorn \
    --set primary.persistence.size=100Mi
    --set service.type=NodePort


    helm upgrade --install mysql-userdb bitnami/mysql \
      --namespace backend-app \
      --set architecture=standalone \
      --set auth.rootPassword=kim1234 \
      --set auth.username=admin \
      --set auth.password=kim1234 \
      --set auth.database=usersv \
      --set primary.persistence.enabled=true \
      --set primary.persistence.storageClass=local-path \
      --set primary.persistence.size=10Mi \
      --set service.type=NodePort \
      --set service.nodePort=30306 \
      --set primary.resources.requests.cpu=10m \
      --set primary.resources.requests.memory=10Mi





      ✔️ MySQL을 특정 노드에 배치하고 싶다면: affinity / nodeSelector
      ✔️ Longhorn 볼륨도 해당 노드의 디스크에 위치시키고 싶다면:

      Longhorn에서 해당 노드만 디스크로 등록

      Data Locality: "BestEffort" or "StrictLocal"
