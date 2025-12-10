#!/usr/bin/env bash
set -e

URI=$1
mongodump --uri=$URI --out /usr/src/app/dump/

echo "Not sending the dump actually anywhere"
# curl -F ‘data=@/usr/src/app/dump/the_database/todos.bson’ https://somewhere

sleep 3600
# mongodump --uri='mongodb://the_username:the_password@mongo-svc.project:27017/the_database' --out $(pwd)