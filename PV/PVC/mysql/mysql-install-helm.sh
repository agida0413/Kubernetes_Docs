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
  --set primary.persistence.size=1Gi \
  --set secondary.persistence.enabled=true \
  --set secondary.persistence.storageClass=local-path \
  --set secondary.persistence.size=1Gi \
  --set service.type=NodePort \
  --set service.nodePort=30306

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
  --set primary.persistence.size=1Gi \
  --set secondary.persistence.enabled=true \
  --set secondary.persistence.storageClass=local-path \
  --set secondary.persistence.size=1Gi \
  --set service.type=NodePort \
  --set service.nodePort=30306

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

