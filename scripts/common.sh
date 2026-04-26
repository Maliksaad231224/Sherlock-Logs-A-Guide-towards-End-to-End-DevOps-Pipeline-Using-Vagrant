echo "grafana password"
kubectl get secret -n monitoring monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 --decode

echo "
echo "======================================"
echo "📊 FETCHING MONITORING URLS"
echo "======================================"

NAMESPACE="monitoring"

# -----------------------------
# GET NODE IP
# -----------------------------
NODE_IP="192.168.56.10"

# -----------------------------
# GET GRAFANA PORT
# -----------------------------
GRAFANA_PORT=$(kubectl get svc -n $NAMESPACE monitoring-grafana \
-o jsonpath='{.spec.ports[0].nodePort}')

# -----------------------------
# GET PROMETHEUS PORT
# -----------------------------
PROM_PORT=$(kubectl get svc -n $NAMESPACE monitoring-kube-prometheus-prometheus \
-o jsonpath='{.spec.ports[0].nodePort}')

# -----------------------------
# BUILD URLS
# -----------------------------
GRAFANA_URL="http://$NODE_IP:$GRAFANA_PORT"
PROM_URL="http://$NODE_IP:$PROM_PORT"

# -----------------------------
# OUTPUT
# -----------------------------
echo ""
echo "🎯 GRAFANA"
echo "--------------------------------------"
echo $GRAFANA_URL

echo ""
echo "🎯 PROMETHEUS"
echo "--------------------------------------"
echo $PROM_URL

echo ""
echo "======================================"
echo "✅ DONE"
echo "======================================"

echo "======================================"
echo "📊 ELK STACK (LOGGING) URL FETCHER"
echo "======================================"
NAMESPACE="logging"
# -----------------------------
# GET NODE IP
# -----------------------------
NODE_IP="192.168.56.10"
# -----------------------------
# GET ELASTICSEARCH PORT
# -----------------------------
ES_PORT=$(kubectl get svc elasticsearch -n $NAMESPACE -o jsonpath='{.spec.ports[0].nodePort}')
# -----------------------------
# GET KIBANA PORT
# -----------------------------
KIBANA_PORT=$(kubectl get svc kibana -n $NAMESPACE -o jsonpath='{.spec.ports[0].nodePort}')
# -----------------------------
# BUILD URLs
# -----------------------------
ES_URL="http://$NODE_IP:$ES_PORT"
KIBANA_URL="http://$NODE_IP:$KIBANA_PORT"
# -----------------------------
# OUTPUT
# -----------------------------
echo ""
echo "📦 Elasticsearch"
echo "--------------------------------------"
echo $ES_URL
echo ""
echo "📊 Kibana"
echo "--------------------------------------"
echo $KIBANA_URL
echo ""
echo "======================================"
echo "✅ DONE"
echo "======================================"

echo "======================================"
echo "🌐 APPLICATION URLS"
echo "======================================"

FRONTEND_PORT=$(kubectl get svc frontend-service -o jsonpath='{.spec.ports[0].nodePort}')
BACKEND_PORT=$(kubectl get svc backend-service -o jsonpath='{.spec.ports[0].nodePort}')

echo "Frontend: http://$NODE_IP:$FRONTEND_PORT"
echo "Backend : http://$NODE_IP:$BACKEND_PORT"

echo "======================================"