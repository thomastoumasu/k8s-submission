# 3.11 requests and limits
# https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/
# By keeping a Pod's memory/CPU request low, you give the Pod a good chance of being scheduled. 
# By having a memory/CPU limit that is greater than the memory/CPU request, you accomplish two things:
# The Pod can have bursts of activity where it makes use of memory/CPU that happens to be available.
# The amount of memory/CPU a Pod can use during a burst is limited to some reasonable amount.
# Example:
#   resources:
#     requests: # kube-scheduler uses this information to decide which node to place the Pod on and reserves at least this amount specifically for that container to use
#         memory: "64Mi" # in bytes, i for power of 2
#         cpu: "250m" # 1 CPU unit is equivalent to 1 physical CPU core, or 1 virtual core, depending on whether the node is a physical host or a virtual machine running inside a physical machine.
#     limits: # kubelet enforces the limit so that the running container is not allowed to use more of that resource:
#       memory: "128Mi" # Above this, the kernel may terminate the container (OOMKilled, Out Of Memory) when it detects memory pressure. 
#       cpu: "500m" # Around this, the kernel will restrict access to the CPU (CPU throttling).

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
kubectl create namespace project

# set kube-config to point at the cluster
# gcloud container clusters get-credentials $CLUSTER_NAME --zone=$LOCATION
gcloud container clusters get-credentials $CLUSTER_NAME --location=$CONTROL_PLANE_LOCATION

# check: Each node has a maximum capacity for each of the resource types: the amount of CPU and memory it can provide for Pods. 
kubectl get nodes
kubectl describe nodes 
kubectl describe node/

# push on main to deploy project on namespace project (see .github/workflows/deploy_the-project.yaml)

# eventually connect the domain with the Gateway IP (in cloudflare)
kubectl get gateway shared-gateway -n infra

# confirm backend is connected to the database: "--backend connected to MongoDB"
kubens project
BACKENDPOD=$(kubectl get pods -o=name | grep backend)
kubectl logs $BACKENDPOD

# get pods status
POD=$BACKENDPOD
kubectl get pods $POD --no-headers -o custom-columns=":status.phase"
kubectl get pod $POD --output=yaml
kubectl describe pod $POD
# how much does it use
kubectl top pod $POD --namespace=cpu-example
kubectl describe nodes

# # debug
# kubectl delete -f ./the_project/mongo/manifests/dumper.yaml
kubectl describe cronjobs/periodic-dumper
kubectl describe job/periodic-dumper-29440029
kubectl logs pod/periodic-dumper-29440029-ghq95 # should see the dump: Copying file:///usr/src/app/dump/the_database/todos-2025-12-22T11-09-01.bson to gs://thomastoumasu_k8s-bucket/todos-2025-12-22T11-09-01.bson
# kubectl describe pod/dumper 
# kubectl logs -f pod/dumper 
# kubectl exec -it dumper -- sh 
#   BUCKET="thomastoumasu_k8s-bucket"
#   URI="mongodb://the_username:the_password@mongo-svc.project:27017/the_database"
#   mongodump --uri=$MONGO_URI --out /usr/src/app/dump/
#   NOW=$(date +'%Y-%m-%dT%H-%M-%S')
#   FILENAME="/usr/src/app/dump/the_database/todos-${NOW}.bson"
#   mv /usr/src/app/dump/the_database/todos.bson $FILENAME
#   curl -X GET -H "Authorization: Bearer $(gcloud auth print-access-token)" "https://storage.googleapis.com/storage/v1/b/${BUCKET}/o"
#   gcloud storage cp $FILENAME gs://${BUCKET}


# # debug: additional permissions
# gcloud storage buckets add-iam-policy-binding gs://${BUCKET} \
#     --role=roles/storage.objectViewer \
#     --member=principal://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${PROJECT_ID}.svc.id.goog/subject/ns/project/sa/${KSA_NAME} \
#     --condition=None

# gcloud storage buckets add-iam-policy-binding gs://${BUCKET} \
#     --role=roles/storage.objectCreator \
#     --member=principal://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${PROJECT_ID}.svc.id.goog/subject/ns/project/sa/${KSA_NAME} \
#     --condition=None

# gcloud storage buckets add-iam-policy-binding gs://${BUCKET} \
#     --role=roles/storage.admin \
#     --member=principal://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${PROJECT_ID}.svc.id.goog/subject/ns/project/sa/${KSA_NAME} \
#     --condition=None

# gcloud storage buckets add-iam-policy-binding gs://${BUCKET} \
#     --role=roles/storage.objectAdmin \
#     --member=principal://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${PROJECT_ID}.svc.id.goog/subject/ns/project/sa/${KSA_NAME} \
#     --condition=None


# # debug: other way
###
# gcloud iam service-accounts create access-gcs \
#     --project=${PROJECT_ID}

# gcloud projects add-iam-policy-binding $PROJECT_ID \
#     --member "serviceAccount:access-gcs@${PROJECT_ID}.iam.gserviceaccount.com" \
#     --role "roles/storage.admin"

# gcloud container clusters get-credentials $CLUSTER_NAME --zone $LOCATION --project $PROJECT_ID

# kubectl create serviceaccount gcs-access-ksa \
#     --namespace project

# gcloud iam service-accounts add-iam-policy-binding access-gcs@${PROJECT_ID}.iam.gserviceaccount.com \
#     --role roles/iam.workloadIdentityUser \
#     --member "serviceAccount:${PROJECT_ID}.svc.id.goog[project/gcs-access-ksa]"

# kubectl annotate serviceaccount gcs-access-ksa \
#     --namespace project \
#     iam.gke.io/gcp-service-account=access-gcs@${PROJECT_ID}.iam.gserviceaccount.com