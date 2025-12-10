
# # todo generator sh bin/bash/ex2_9.sh
# sh reset_cluster.sh
sh bin/bash/ex2_8.sh

kubectl apply -f ./the_project/backend/generator/manifests/cronjob.yaml
# it does the same as this with a prepared container:
# exec -it alpine-curl -- sh
# string=$(curl -I https://en.wikipedia.org/wiki/Special:Random | grep location) && url=${string#"location: "}
# # https://stackoverflow.com/questions/41746505/bash-cant-append-a-string-to-an-existing-string-it-appears-to-overwrite-the
# url="${url//$'\r'/}"
# curl --header "Content-Type: application/json" --request POST --data '{"text":"'$url'"}' http://backend-svc:2345/api/todos

# kubectl delete -f ./the_project/backend/generator/manifests/cronjob.yaml

# # optional: mongo dump

# # # mongo dump sh bin/bash/ex2_9.sh
# # sh reset_cluster.sh
# # sh bin/bash/ex2_8.sh

# kubectl apply -f ./the_project/mongo/manifests/dumper.yaml
# # it does the same as this with a prepared container:
# # POD=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep mongo) && kubectl exec -it $POD -- sh
# # mongodump -u the_username -p the_password --db the_database --collection todos

# # kubectl delete -f ./the_project/mongo/manifests/dumper.yaml

# # check the dump was succesfull
# kubectl logs -f dumper

# # copy the dump locally
# kubectl cp dumper:/usr/src/app/dump/the_database/todos.bson ./the_project/mongo/dump/the_database/todos.bson

# # # maybe useful for copy pasting
# # kubectl exec -it mongo-debug -- mongodump --uri='mongodb://the_username:the_password@mongo-svc.project:27017/the_database' --out $(pwd)
# # kubectl cp ${POD}:dump/the_database/todos.bson ./the_project/mongo/dump/the_database/todos.bson
# # kubectl cp dumper:/usr/src/app/dump/the_database/todos.bson ./the_project/mongo/dump/the_database/todos.bson
