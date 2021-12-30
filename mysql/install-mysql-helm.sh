kubectl create ns dbaas
helm install demo-mysql-cluster-01 bitnami/mysql --values bitnami-mysql-helm-values.yaml -n dbaas