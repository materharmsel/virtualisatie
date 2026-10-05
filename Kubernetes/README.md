# Week 6 - Kubernetes (Minikube)

Maarten ter Harmsel - 587328

## Cluster starten

```
minikube start --kubernetes-version=stable --nodes=2 --cni=flannel --driver=docker
```

## webapp-587328 (eis 1 t/m 4)

Eigen nginx-image met naam, studentnummer, versie en de naam van de Pod die antwoordt.

```
docker build -t webapp-587328:v1 --build-arg VERSIE=1 webapp-587328
docker build -t webapp-587328:v2 --build-arg VERSIE=2 webapp-587328
minikube image load webapp-587328:v1
minikube image load webapp-587328:v2
kubectl apply -f webapp-587328/webapp-deployment.yaml
minikube service webapp-svc-587328
```

- 3 Pods via Deployment -> ReplicaSet
- Pod stoppen: `kubectl delete pod <naam>` -> ReplicaSet maakt een nieuwe
- Update: `kubectl set image deployment/webapp-587328 webapp=webapp-587328:v2`
- Service type NodePort (30080)

## wordpress-587328 (eis 5)

WordPress + MySQL met PersistentVolume en PersistentVolumeClaim (hostPath op node `minikube`).

```
kubectl apply -f wordpress-587328/storage.yaml -f wordpress-587328/mysql.yaml -f wordpress-587328/wordpress.yaml
minikube service wordpress-svc-587328
```
