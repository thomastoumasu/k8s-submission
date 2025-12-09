# # monitoring sh bin/bash/ex2_10.sh
# sh reset_cluster.sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update
kubectl create namespace prometheus
helm install prometheus-community/kube-prometheus-stack --generate-name --namespace prometheus
kubectl get po -n prometheus
GRAFANA_POD=$(kubectl get pods -n prometheus --no-headers -o custom-columns=":metadata.name" | grep grafana)
kubectl -n prometheus port-forward $GRAFANA_POD 3000

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace loki-stack
helm upgrade --install loki --namespace=loki-stack grafana/loki-stack --set loki.image.tag=2.9.3
kubectl get all -n loki-stack

sh bin/bash/ex2_8.sh