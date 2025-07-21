# local-path-provisioner 설치
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.20/deploy/local-path-storage.yaml

# default storage class로 변경
kubectl patch storageclass local-path  -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# 확인
kubectl get sc
kubectl get all -n local-path-storage


--->
NAME                   PROVISIONER             AGE
local-path (default)   rancher.io/local-path   10s



--->ex

primary:
  persistence:
    enabled: true
    storageClass: local-path  # 자동으로 PV가 붙음
    size: 8Gi