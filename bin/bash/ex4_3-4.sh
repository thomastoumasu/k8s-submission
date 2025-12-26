# 4.3-4 Prometheus and canary update

CLUSTER_NAME=dwk-cluster
LOCATION=europe-north1-b
CONTROL_PLANE_LOCATION=europe-north1-b
PROJECT_ID=dwk-gke-480809
PROJECT_NUMBER=267537331918

# create cluster
gcloud -v
gcloud auth login
gcloud config set project $PROJECT_ID
gcloud services enable container.googleapis.com
gcloud container clusters create $CLUSTER_NAME --zone=$LOCATION \
  --cluster-version=1.32 --disk-size=32 --num-nodes=3 --machine-type=e2-small \
  --gateway-api=standard
kubectl cluster-info
kubectl create namespace exercises

# set kube-config to point at the cluster
# gcloud container clusters get-credentials $CLUSTER_NAME --zone=$LOCATION
gcloud container clusters get-credentials $CLUSTER_NAME --location=$CONTROL_PLANE_LOCATION

# install argo
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
brew install argoproj/tap/kubectl-argo-rollouts
kubectl argo rollouts version

kubectl apply -f ./manifests/gateway.yaml 
# deploy postgres, pingpong and log-output in namespace exercises
kubectl apply -f ./pingpong/postgres/manifests/config-map.yaml
kubectl apply -f ./pingpong/postgres/manifests/statefulset_gke.yaml
kubectl apply -f ./pingpong/manifests/deployment_gke.yaml
kubectl apply -f ./pingpong/manifests/service_gke_gat.yaml
kubectl apply -f ./pingpong/manifests/route_gke.yaml
kubectl apply -f ./pingpong/manifests/lb-healthcheckpolicy.yaml 
kubectl apply -f ./log_output/manifests/config-map.yaml
kubectl apply -f ./log_output/manifests/deployment_gke.yaml
kubectl apply -f ./log_output/manifests/service_gke_gat.yaml
kubectl apply -f ./log_output/manifests/route_gke.yaml
kubectl apply -f ./log_output/manifests/lb-healthcheckpolicy.yaml 

# check cluster is accessible from outside via the gateway
kubectl get gateway pingpong-gateway
kubectl get httproutes
kubectl describe httproutes ...
# curl ADDRESS of pingpong-gateway

# start prometheus, see ex2_10.sh for installing
kubectl create namespace prometheus
helm install prometheus-community/kube-prometheus-stack --generate-name --namespace prometheus
kubectl get po -n prometheus
POD=$(kubectl get pods -n prometheus --no-headers -o custom-columns=":metadata.name" | grep prometheus-kube-prometheus-stack)
kubectl -n prometheus port-forward $POD 9090:9090
# query: kube_pod_info{created_by_kind="StatefulSet"} -> gives 3 for prometheus alone, 4 with mongo from exercises

# # do canary release of pingpong instead of previous normal rollout, first based on the restart rate like in the examples
# kubectl delete -f ./pingpong/manifests/deployment_gke.yaml
# kubectl apply -f ./pingpong/manifests/analysis-restart-rate.yaml
# kubectl apply -f ./pingpong/manifests/canary-rollout.yaml # uncomment - templateName: restart-rate
# kubectl argo rollouts get rollout pingpong-dep --watch 

# do canary release based on CPU usage (set the limit extra low to fail the analysis)
kubectl apply -f ./pingpong/manifests/analysis-cpu-usage.yaml
kubectl apply -f ./pingpong/manifests/canary-rollout.yaml
kubectl argo rollouts get rollout pingpong-dep --watch 

# # fundus queries
# scalar(sum(rate(container_cpu_usage_seconds_total{container!="", namespace="exercises"}[2m])))
# the CPU usage is expressed in the number of used CPU cores
# The {container!~""} filter is needed for removing CPU usage metrics for cgroups hierarchy, since these metrics are already included with non-empty container labels.
# sum(rate(container_cpu_usage_seconds_total{container!=""}[5m])) by (namespace)
# scalar(sum(kube_pod_container_status_restarts_total{namespace="default", container="flaky-update"}) - sum(kube_pod_container_status_restarts_total{namespace="default", container="flaky-update"} offset 2m))
# machine_cpu_cores
# container_memory_working_set_bytes
# container_memory_max_usage_bytes
# avg(rate(node_cpu_seconds_total{mode!="idle"}[5m])) by (instance)
# avg_over_time(node_memory_MemTotal_bytes[1h])

