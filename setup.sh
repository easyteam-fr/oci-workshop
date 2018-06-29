#!/usr/bin/env bash

TF_VAR_tenancy=$(grep "^tenancy=" ~/.oci/config | cut -d'=' -f2)
TF_VAR_user=$(grep "^user=" ~/.oci/config | cut -d'=' -f2)
TF_VAR_fingerprint=$(grep "^fingerprint=" ~/.oci/config | cut -d'=' -f2)
TF_VAR_key_file=$(grep "^key_file=" ~/.oci/config | cut -d'=' -f2)
TF_VAR_region=$(grep "^region=" ~/.oci/config | cut -d'=' -f2) 

DIR="$(dirname "$0")"

if [[ -f "${DIR}/.env" ]]; then
  source "${DIR}/.env"
fi

export TF_VAR_tenancy TF_VAR_user TF_VAR_fingerprint TF_VAR_key_file
export TF_VAR_region
