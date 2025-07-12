# 설치 ([root@k8s-master monitoring]#)
kubectl apply -f ground/k8s-1.27/loki-stack-2.6.1

# 설치 확인
kubectl get pods -n loki-stack