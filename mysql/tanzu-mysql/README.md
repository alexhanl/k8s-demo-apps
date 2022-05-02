# Tanzu MySql Operator

## Reference
- https://docs.vmware.com/en/VMware-Tanzu-SQL-with-MySQL-for-Kubernetes/1.3/tanzu-mysql-k8s/GUID-install-operator.html
- https://docs.vmware.com/en/VMware-Tanzu-SQL-with-MySQL-for-Kubernetes/1.3/tanzu-mysql-k8s/GUID-architecture.html

wget https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz && tar zxvf helm-v3.6.3-linux-amd64.tar.gz && sudo install linux-amd64/helm /usr/local/bin/helm


## Installation
export HELM_EXPERIMENTAL_OCI=1
helm registry login registry.tanzu.vmware.com
helm chart pull registry.tanzu.vmware.com/tanzu-mysql-for-kubernetes/tanzu-mysql-operator-chart:1.3.0

CHART_DIR=$(mktemp -d /tmp/tanzu-mysql-operator-chart:1.3.0.XXXXX)

helm chart export registry.tanzu.vmware.com/tanzu-mysql-for-kubernetes/tanzu-mysql-operator-chart:1.3.0 -d ${CHART_DIR}

kubectl create namespace tanzu-mysql-for-kubernetes-system

kubectl create secret docker-registry tanzu-image-registry \
--docker-server=https://registry.tanzu.vmware.com/ \
--docker-username="liangh@vmware.com" \
--docker-password="" \
--namespace tanzu-mysql-for-kubernetes-system

helm install --wait my-mysql-operator tanzu-sql-with-mysql-operator/ --namespace=tanzu-mysql-for-kubernetes-system 

## instance management

kubectl create namespace hr-dev

### Create MySQL instance

kubectl create secret --namespace=hr-dev \
docker-registry tanzu-image-registry  \
--docker-server=https://registry.tanzu.vmware.com/ \
--docker-username="liangh@vmware.com"  \
--docker-password=""


kubectl apply -f hr-dev-mysql.yaml -n hr-dev

### First login via root
只能在 primary container 本地，使用 root 登录

kubectl exec --stdin --tty pod/mysql-hr-dev-0 -c mysql -- /bin/bash

mysql -uroot -p$(cat $MYSQL_ROOT_PASSWORD_FILE)

#### Create account for application
```
CREATE DATABASE bitnami_wordpress;
CREATE USER 'bn_wordpress'@'%' IDENTIFIED BY 'hunter2';
GRANT ALL PRIVILEGES ON bitnami_wordpress.* TO 'bn_wordpress'@'%';
FLUSH PRIVILEGES;
```

```
mysql> CREATE DATABASE bitnami_wordpress;
Query OK, 1 row affected (0.20 sec)

mysql> CREATE USER 'bn_wordpress'@'%' IDENTIFIED BY 'hunter2';
Query OK, 0 rows affected (0.08 sec)
--- OR, for broader compatibility with older client libraries ---
mysql> CREATE USER 'bn_wordpress'@'%' IDENTIFIED WITH mysql_native_password BY 'hunter2';
Query OK, 0 rows affected (0.08 sec)

mysql> GRANT ALL PRIVILEGES ON bitnami_wordpress.* TO 'bn_wordpress'@'%';
Query OK, 0 rows affected (0.03 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.10 sec)
```

#### Login via application account
```
mysql -h <MySQL Router Service IP> -u bn_wordpress -p
```

```
mysql -h 192.168.220.13 -u bn_wordpress -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1174
Server version: 8.0.26-17 Percona Server (GPL), Release '17', Revision 'd7119cd'

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| bitnami_wordpress  |
| information_schema |
+--------------------+
2 rows in set (0.04 sec)

mysql> use bitnami_wordpress
Database changed
mysql> show tables;
Empty set (0.00 sec)
```

## backup 

minio https self-signed certificate is not supported
use let's encrypt to workaround otherwise use http instead. 


