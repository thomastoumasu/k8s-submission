# eventually delete previous image
docker images
# create images
cd the_project/backend/generator 
docker build -t 2.10 .   
docker build --platform linux/amd64 -t 2.7 . 
# sanity check
docker run --rm -p 3000:3000 --name 2.10 2.10 && curl localhost:8082 
docker tag 2.7 thomastoumasu/k8s-pingpong:2.7-amd && docker push thomastoumasu/k8s-pingpong:2.7-amd && cd ../../../