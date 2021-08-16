#! /usr/bin/env bash

function deleteKind() {
  local project=${1}
  local environment=${2}
  local namespace="${environment}-${3}"
  local kind="${4}"

  gcloud dataflow jobs run "${environment}_delete_kind_${kind}" \
    --gcs-location gs://dataflow-templates/latest/Datastore_to_Datastore_Delete \
    --region "europe-west4" \
    --project "$project" \
    --network "${environment}-dataflow-vpc" \
    --parameters \
datastoreReadGqlQuery="SELECT * FROM ${kind}",\
datastoreReadProjectId="${project}",\
datastoreReadNamespace="${namespace}",\
datastoreDeleteProjectId="${project}"
}

if [ -z $1 ]; then
  echo "syntax is: 'delete-entities.sh PROJECT ENVIRONMENT NAMESPACE KIND"
else
  deleteKind $1 $2 $3 $4
fi
