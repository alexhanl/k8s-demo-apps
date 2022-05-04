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
kubectl create secret generic mysql-pass --from-literal=password='d29yZHByZXNz'

### Create K8s resources for WordPress front
kubectl apply -f wordpress-deployment.yaml

kubectl get svc

