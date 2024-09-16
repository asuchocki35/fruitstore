#!/bin/bash

echo
echo "Deploying Fruitstore app"

echo
echo "creating Persistent Volume"
kubectl apply -f ./pv.yaml

echo
echo "Create Persistent Volume Claim"
kubectl apply -f ./pvc.yaml

echo
echo "Create the App Deployment"
kubectl apply -f ./deployment.yaml

echo
echo "Create the Service"
kubectl apply -f ./service.yaml

echo
echo "Completed Application Deployment"