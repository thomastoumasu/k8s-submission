# ingress service - to access app from outside
sh clear.sh  

# # create image of pingpong
# cd pingpong
# docker build -t 1.9 .   
# # sanity check
# docker run --rm -p 3000:3000 --name 1.9 1.9 && curl localhost:3000
# docker tag 1.9 thomastoumasu/k8s-pingpong:1.9
# docker push thomastoumasu/k8s-pingpong:1.9  
# cd ..

# create cluster
k3d cluster create -p 8081:80@loadbalancer --agents 2

kubectl apply -f ./log_output/manifests/deployment.yaml
kubectl apply -f ./log_output/manifests/service.yaml
kubectl apply -f ./pingpong/manifests/deployment.yaml
kubectl apply -f ./pingpong/manifests/service.yaml
kubectl apply -f manifests/ingress.yaml

# check that app is accessible on host port
kubectl rollout status deployment log-output-dep
kubectl rollout status deployment pingpong-dep

sleep 10 
curl localhost:8081
curl localhost:8081/pingpong

# check, should see the svc on 2345 and 1234 as well as the ingress on 80
# kubectl get svc,ing