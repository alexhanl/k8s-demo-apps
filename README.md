# k8s-demo-apps
This is a collection of manifests of various k8s demo applications

## Hello-Kubernetes
- http://hello-kubernetes.demo.corp.tanzu
- `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout hello-kubernetes.demo.corp.tanzu.key -out hello-kubernetes.demo.corp.tanzu.crt -subj "/CN=hello-kubernetes.demo.corp.tanzu/O=VMware/"`
- `kubectl create secret tls hello-kubernetes-tls-secret --key hello-kubernetes.demo.corp.tanzu.key --cert hello-kubernetes.demo.corp.tanzu.crt`

## Kuard
- `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout kuard.demo.corp.tanzu.key -out kuard.demo.corp.tanzu.crt -subj "/CN=kuard.demo.corp.tanzu/O=VMware/"`

- `kubectl create secret tls kuard-tls-secret --key kuard.demo.corp.tanzu.key --cert kuard.demo.corp.tanzu.crt`

## my-web-demo
- http://myweb.demo.corp.tanzu/slowresponse?waitFor=10
- http://myweb.demo.corp.tanzu/hello?myName=alex
- http://myweb.demo.corp.tanzu/url-not-exist


## simple-web-demo
- `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout demo.corp.tanzu.key -out demo.corp.tanzu.crt -subj "/CN=*.demo.corp.tanzu/O=VMware/"`
