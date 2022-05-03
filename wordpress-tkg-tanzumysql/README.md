# Wordpress
To deploy wordpress. type kubectl apply -k .

kubectl create ns wordpress
kubectl config set-context --current --namespace=wordpress


## create database
```
CREATE DATABASE wordpress;
CREATE USER 'wp'@'%' IDENTIFIED BY 'wordpress';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp'@'%';
FLUSH PRIVILEGES;
```

kubectl run mysql-client --image=ghcr.io/alexhanl/mysql:8.0 --rm -it -- bash
mysql -h wp-mysql -u wp -p

## create app
