// kubelet 상태 확인
1) systemctl status kubelet       // systemctl (restart or start) kubelet
2) journalctl -u kubelet | tail -10

// 상태 확인 -> 상세 로그 확인 -> 10분 구글링 -> VM 재기동 -> Cluster 재설치 ->  답을 찾을 때 까지 구글링

// containerd 상태 확인
1) systemctl status containerd
2) journalctl -u containerd | tail -10

// 노드 상태 확인
1) kubectl get nodes -o wide
2) kubectl describe node k8s-master

// Pod 상태 확인
1) kubectl get pods -A -o wide
// Event 확인 (기본값: 1h)
2-1) kubectl get events -A
2-2) kubectl events -n anotherclass-123 --types=Warning  (or Normal)
// Log 확인
3-1) kubectl logs -n anotherclass-123 <pod-name> --tail 10    // 10줄 만 조회하기
3-2) kubectl logs -n anotherclass-123 <pod-name> -f           // 실시간으로 조회 걸어 놓기
3-3) kubectl logs -n anotherclass-123 <pod-name> --since=1m   // 1분 이내에 생성된 로그만 보기