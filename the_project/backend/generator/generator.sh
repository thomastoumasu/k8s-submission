#!/usr/bin/env sh
set -e

usage() {
  echo "this script needs the backend url of the Todo app, such as http://backend-svc:2345/api/todos. Set URL environment variable in job manifest."
  exit 1
}

if [ $URL ]; then
  # random url is returned in response header under location: 
  string=$(curl -I https://en.wikipedia.org/wiki/Special:Random | grep location) 
  url=${string#"location: "}
  # remove CR character at the end of the variable
  url="${url//$'\r'/}"
  # insert a new Todo with the random url
  curl --header "Content-Type: application/json" --request POST --data '{"text":"Read '$url'"}' $URL 
else 
  usage
fi