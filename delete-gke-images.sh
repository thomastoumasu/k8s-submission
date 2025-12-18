# clean up https://docs.cloud.google.com/artifact-registry/docs/repositories/cleanup-policy#json
gcloud artifacts repositories set-cleanup-policies my-repository --project='dwk-gke-480809' --location='europe-north1' --policy='delete-policy.json' --no-dry-run

# if dry run, see the result
gcloud logging read 'protoPayload.serviceName="artifactregistry.googleapis.com" AND protoPayload.request.parent="projects/dwk-gke-480809/locations/europe-north1/repositories/my-repository/packages/-" AND protoPayload.request.validateOnly=true' --resource-names="projects/dwk-gke-480809" --project=dwk-gke-480809

# check after one day
gcloud artifacts docker images list europe-north1-docker.pkg.dev/dwk-gke-480809/my-repository/backend --include-tags > after.txt