# iscsi 설치 및 상태 확인
yum --setopt=tsflags=noscripts install iscsi-initiator-utils
echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi
systemctl enable iscsid
systemctl start iscsid
sudo systemctl start iscsid
sudo systemctl enable iscsid

# longhorn 배포
kubectl apply -f https://raw.githubusercontent.com/k8s-1pro/install/main/ground/k8s-1.27/longhorn-1.4.2/longhorn.yaml

# replicas 수 조정
kubectl scale deploy -n longhorn-system csi-attacher --replicas=1
kubectl scale deploy -n longhorn-system csi-provisioner --replicas=1
kubectl scale deploy -n longhorn-system csi-resizer --replicas=1
kubectl scale deploy -n longhorn-system csi-snapshotter --replicas=1

# 설치 확인
kubectl get pod -n longhorn-system