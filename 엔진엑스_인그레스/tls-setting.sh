mkdir tls && cd tls

// 개인키 생성
openssl genrsa -out tls.key 2048

// 인증서 서명 요청 (CSR) 생성
openssl req -new -x509 -key tls.key -out tls.crt -days 3650 -subj "/CN=my.com"

// TLS 타입의 Secret 생성
kubectl create secret tls backend-app-t -n backend-app --cert=tls.crt --key=tls.key
// 확인
kubectl get secret backend-app-t  -n backend-app -o yaml





[root@k8s-master ~]# kubectl edit ingress -n anotherclass-322 portal-3222
---
spec:
  ingressClassName: nginx
  rules:
  - host: portal.com
    http:
      paths:
      - backend:
          service:
            name: portal-3222
            port:
              number: 80
        path: /
        pathType: Prefix
  tls:                                 # 추가
    - hosts:                           # 추가
        - portal.com                   # 추가
      secretName: portal-3222-tls      # 추가
status:
  loadBalancer: {}





  kubectl edit -n anotherclass-322 ingress portal-3222
  --
    annotations:
      nginx.ingress.kubernetes.io/configuration-snippet: |
        if ($scheme = http) {
          return 301 https://$host:31443$request_uri;
        }
  --