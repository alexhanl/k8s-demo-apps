# Tanzu MySql Operator

## Reference
- https://docs.vmware.com/en/VMware-Tanzu-SQL-with-MySQL-for-Kubernetes/1.3/tanzu-mysql-k8s/GUID-install-operator.html


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

helm install --wait my-mysql-operator tanzu-sql-with-mysql-operator/

helm install --wait my-mysql-operator tanzu-sql-with-mysql-operator/ --namespace=tanzu-mysql-for-kubernetes-system 