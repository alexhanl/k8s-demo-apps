# k8s-demo-apps
This is a collection of manifests of various k8s demo applications

## Hello-Kubernetes
This demostrates using kubernetes standard way to enable HTTPS, i.e. the developer creates the secrets and ingress uses the secret.  AVI will load the key and certs from the secret. 
- https://hello-kubernetes.demo.corp.tanzu
- `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout hello-kubernetes.demo.corp.tanzu.key -out hello-kubernetes.demo.corp.tanzu.crt -subj "/CN=hello-kubernetes.demo.corp.tanzu/O=VMware/"`
- `kubectl create secret tls hello-kubernetes-tls-secret --key hello-kubernetes.demo.corp.tanzu.key --cert hello-kubernetes.demo.corp.tanzu.crt`

## Kuard
This demostrates (1) the AVI hostrule and httprule and (2) the contour httpproxy
- `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout demo.corp.tanzu.key -out demo.corp.tanzu.crt -subj "/CN=*.demo.corp.tanzu/O=VMware/"`

### the AVI hostrule and httprule
- Load the certificate/key to the avi controller, name it `demo-corp-tanzu-wildcard-cert`
- `curl -k --silent https://kuard.demo.corp.tanzu/ 2>&1 | grep hostname`

### the contour httpproxy
- `kubectl create secret tls demo-corp-tanzu-wildcard-tls-secret --key demo.corp.tanzu.key --cert demo.corp.tanzu.crt`


## my-web-demo
This is a home grown sample application to demonstrate the various unhealth http responses. 
- http://myweb.demo.corp.tanzu/slowresponse?waitFor=10
- http://myweb.demo.corp.tanzu/hello?myName=alex
- http://myweb.demo.corp.tanzu/url-not-exist
- http://myweb.demo.corp.tanzu/slowresponse?waitFor=abc


## simple-web-demo
- `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout demo.corp.tanzu.key -out demo.corp.tanzu.crt -subj "/CN=*.demo.corp.tanzu/O=VMware/"`

