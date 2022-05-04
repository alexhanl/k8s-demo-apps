# Wordpress

## Preparation
kubectl create namespace wordpress
kubectl config set-context --current --namespace=wordpress

export TANZU_REGISTRY_USER=
export TANZU_REGISTRY_PASSWORD=

kubectl create secret \
docker-registry tanzu-image-registry  \
--docker-server=https://registry.tanzu.vmware.com/ \
--docker-username="${TANZU_REGISTRY_USER}"  \
--docker-password="${TANZU_REGISTRY_PASSWORD}"

## WordPress MySQL database

### Create MySQL instance without TLS using Tanzu MySQL Operator
kubectl apply -f mysql-deployment.yaml

### Create WordPress database
kubectl exec --stdin --tty pod/wordpress-mysql-0 -c mysql -- /bin/bash

mysql -uroot -p$(cat $MYSQL_ROOT_PASSWORD_FILE)

```
SET PERSIST require_secure_transport=OFF;

CREATE DATABASE wordpress;
CREATE USER 'wordpress'@'%' IDENTIFIED BY 'wordpress';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%';
FLUSH PRIVILEGES;
```
### Verify the connectivity 
kubectl run mysql-client --image=ghcr.io/alexhanl/mysql:8.0 --rm -it -- bash
mysql -h wordpress-mysql -u wordpress -p

## WordPress Front single instance deployment
### Create secret for MySQL password (wordpress)
kubectl create secret generic mysql-pass --from-literal=password='wordpress'

### Create K8s resources for WordPress front
kubectl apply -f wordpress-deployment.yaml


### Visit wordpress
kubectl get ingress
visit http://wordpress.demo.corp.tanzu




# Deploy Wordpress with bitnami helm and MySQL(TLS)

Reference: https://docs.vmware.com/en/VMware-Tanzu-SQL-with-MySQL-for-Kubernetes/1.3/tanzu-mysql-k8s/GUID-connecting-apps.html#configure-your-app-with-mysql-user-and-connectivity-information

kubectl create namespace wordpress2
kubectl config set-context --current --namespace=wordpress2

``` bash
cat << EOF | kubectl apply -f -
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ca-certificate
spec:
  isCA: true
  issuerRef:
    name: selfsigned-issuer
  secretName: ca-secret
  commonName: ca-cert
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: tls-issuer
spec:
  ca:
    secretName: ca-secret
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: tls-certificate
spec:
  isCA: false
  dnsNames:
    - mysql-sample.wordpress2 # See note after the code excerpt
  secretName: mysql-tls-secret
  issuerRef:
    name: tls-issuer
EOF
```

``` bash
cat << EOF | kubectl apply -f -
apiVersion: with.sql.tanzu.vmware.com/v1
kind: MySQL
metadata:
  name: mysql-sample
spec:
 imagePullSecretName: tanzu-image-registry
 serviceType: ClusterIP
 tls:
   secret:
     name: mysql-tls-secret
EOF
```

