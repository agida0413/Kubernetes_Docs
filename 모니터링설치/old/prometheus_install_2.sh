# 설치 ([root@k8s-master monitoring]#)
kubectl apply --server-side -f ground/k8s-1.27/prometheus-2.44.0/manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring
kubectl apply -f ground/k8s-1.27/prometheus-2.44.0/manifests

# 설치 확인 ([root@k8s-master]#) 
kubectl get pods -n monitoring