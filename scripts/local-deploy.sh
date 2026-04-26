#!/bin/bash
set -e


echo "======================================"
echo "📦 Building FRONTEND"
echo "======================================"
cd ~/project/frontend
DOCKER_USERNAME=tumbaoka
sudo docker build -t $DOCKER_USERNAME/sherlock-logs-frontend:latest .
sudo docker tag $DOCKER_USERNAME/sherlock-logs-frontend:latest $DOCKER_USERNAME/sherlock-logs-frontend:prod
echo "🚀 Pushing FRONTEND images..."
sudo docker push $DOCKER_USERNAME/sherlock-logs-frontend:latest
sudo docker push $DOCKER_USERNAME/sherlock-logs-frontend:prod
echo "frontend pushed successfully"
#######################################
# BACKEND BUILD + PUSH
#######################################
echo "======================================"
echo "📦 Building BACKEND"
echo "======================================"
cd ~/project/backend
sudo docker build -t $DOCKER_USERNAME/sherlock-logs-backend:latest .
sudo docker tag $DOCKER_USERNAME/sherlock-logs-backend:latest $DOCKER_USERNAME/sherlock-logs-backend:prod
echo "🚀 Pushing BACKEND images..."
sudo docker push $DOCKER_USERNAME/sherlock-logs-backend:latest
sudo docker push $DOCKER_USERNAME/sherlock-logs-backend:prod

echo "backend pushed successfully"
#######################################
# KUBERNETES DEPLOYMENT
#######################################

echo "Wait 10 seconds for images to be available in registry..."
sleep 10
echo "======================================"
echo "☸️ DEPLOYING TO KUBERNETES"
echo "======================================"

cd ~/project
kubectl apply -f manifests/kubernetes/
echo "🔄 Restarting deployments..."
kubectl rollout restart deployment/sherlock-logs-frontend || true
kubectl rollout restart deployment/sherlock-logs-backend || true
echo "======================================"
echo "📊 CLUSTER STATUS"
echo "======================================"
kubectl get pods
kubectl get svc
kubectl get all
echo "======================================"
echo "✅ PIPELINE COMPLETED SUCCESSFULLY"
echo "======================================"
 
echo "It takes 100 seconds to load the pods and services. Fetching final status..."
sleep 100
kubectl get pods

