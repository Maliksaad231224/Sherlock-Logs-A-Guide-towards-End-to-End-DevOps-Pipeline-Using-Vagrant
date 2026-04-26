cd ..
kubectl create namespace logging
kubectl apply -f manifests/logging/ 
kubectl get svc -n logging

echo "======================================"
echo "📊 FETCHING LOGGING URLS"
echo "======================================"
sleep 10
kubectl get pods -n logging
kubectl get nodes -o wide