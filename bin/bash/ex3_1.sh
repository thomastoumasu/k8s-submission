# # setup gke sh bin/bash/ex3_1.sh
# https://courses.mooc.fi/org/uh-cs/courses/devops-with-kubernetes/chapter-4/introduction-to-google-kubernetes-engine
k3d cluster delete
docker rm -vf $(docker ps -aq) 
docker rmi -f $(docker images -aq)
# docker container prune -f
# docker image prune -f
docker volume prune -f
docker system prune -f
docker builder prune -f  
docker buildx history rm $(docker buildx history ls)
docker network prune -f  

gcloud -v
gcloud auth login
gcloud config set project dwk-gke-480809
gcloud services enable container.googleapis.com
gcloud container clusters create dwk-cluster --zone=europe-north1-b --cluster-version=1.32 --disk-size=32 --num-nodes=3 --machine-type=e2-micro
gcloud container clusters get-credentials dwk-cluster --zone=europe-north1-b
kubectl cluster-info
# to set kube-config to point at the new cluster: gcloud container clusters get-credentials dwk-cluster --zone=europe-north1-b
# delete cluster
# gcloud container clusters delete dwk-cluster --zone=europe-north1-b
