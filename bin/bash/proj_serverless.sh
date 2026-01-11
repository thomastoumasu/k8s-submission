# set up same as ex5.7
CLUSTER_NAME=dwk-cluster
LOCATION=europe-north1-b
CONTROL_PLANE_LOCATION=europe-north1-b
PROJECT_ID=dwk-gke-480809
PROJECT_NUMBER=267537331918
gcloud auth login
gcloud config set project $PROJECT_ID
gcloud services enable container.googleapis.com
gcloud container clusters create $CLUSTER_NAME --zone=$LOCATION \
  --cluster-version=1.32 --disk-size=32 --num-nodes=3 --machine-type=e2-medium 
gcloud container clusters get-credentials $CLUSTER_NAME --location=$CONTROL_PLANE_LOCATION 

kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.18.2/serving-crds.yaml
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.18.2/serving-core.yaml
kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.18.0/kourier.yaml
kubectl patch configmap/config-network -n knative-serving --type merge --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'
# confirm external IP allocated, can take time for GKE
kubectl get service kourier -n kourier-system --watch
# verify installation
kubectl get pods -n knative-serving
# configure DNS
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.18.2/serving-default-domain.yaml

kubectl create namespace project || true
kubens project
# kubectl kustomize ./the_project/kustomize/serverless
kubectl apply -f ./the_project/kustomize/serverless/mongo-config-map.yaml
# put the resources requests lower so that the mongo pod can be scheduled
kubectl apply -f ./the_project/kustomize/serverless/mongo-statefulset_gke.yaml
kubectl apply -f ./the_project/kustomize/serverless/backend-serverless.yaml
kubectl get ksvc
# then in repo k8s-application
cd ../frontend
docker build --platform linux/amd64 --build-arg VITE_BACKEND_URL="http://backend.project.34.88.212.46.sslip.io/api/todos" -t serverless . 
docker tag serverless thomastoumasu/k8s-frontend:serverlessa-amd && docker push thomastoumasu/k8s-frontend:serverlessa-amd
# then again here
kubectl apply -f ./the_project/kustomize/serverless/frontend-serverless.yaml

kubectl get pods
kubectl get ksvc
# for GKE, just curl the IPs

curl -H "Host: backend.project.172.18.0.3.sslip.io" http://localhost:8081/api/todos
curl -H "Host: frontend.project.172.18.0.3.sslip.io" http://localhost:8081
# works for k3s, if localhost alias set up in etc/hosts, however frontend does not connect with backend (axios call probably needs to be changed)


kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl port-forward svc/argocd-server -n argocd 8080:443
# in localhost:8080, log in with admin and this pw: 
kubectl get -n argocd secrets argocd-initial-admin-secret -o yaml | grep -o 'password: .*' | cut -f2- -d: | base64 --decode

kubectl apply -n argocd -f ./the_project/kustomize/serverless/application.yaml

