# eventually delete previous image
docker images
# create images
cd the_project/backend/generator 
docker build -t 2.9 .   
# sanity check
docker run --rm -p 8082:3000 --name 2.9 2.9 && curl localhost:8082 
docker tag 2.9 thomastoumasu/k8s-todo-generator:2.9 && docker push thomastoumasu/k8s-todo-generator:2.9 && cd ../../../