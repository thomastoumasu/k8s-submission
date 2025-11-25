# k3d cluster create -a 2

# kubectl delete -f manifests/deployment.yaml

sh ../builder.sh the_project 1.5

kubectl apply -f manifests/deployment.yaml

POD=$(kubectl get pods -o=name | grep the-project)

kubectl wait --for=condition=Ready $POD

kubectl port-forward $POD 3006:3000