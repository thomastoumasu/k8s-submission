# eventually delete previous image
docker images
# create images
cd the_project/backend/generator 
docker build -t 2.10 .   
# sanity check
docker run --rm -p 3000:3000 --name 2.10 2.10 && curl localhost:8082 
docker tag 2.10 thomastoumasu/k8s-frontend:2.10 && docker push thomastoumasu/k8s-frontend:2.10 && cd ../../../