#!/bin/bash

echo
echo "Deploying Fruitstore DB"

echo
echo "Create Namespace"
kubectl create namespace fruitstore
kubectl config set-context --current --namespace=fruitstore

echo
echo "Creat the PV"
kubectl apply -f ./mariadb-pv.yaml

echo
echo "Create the PVC"
kubectl apply -f ./mariadb-pvc.yaml

echo
echo "Deploy the configmap"
kubectl apply -f ./configmap.yaml

echo
echo "Deploy the Secrets"
kubectl apply -f ./secrets.yaml

echo
echo "Create mariaDB Deployment"
kubectl apply -f ./mariadb-deployment.yaml

echo
echo "Creat the mariaDB service"
kubectl apply -f ./mariadb-service.yaml

echo
echo "Completed DB Deployment"