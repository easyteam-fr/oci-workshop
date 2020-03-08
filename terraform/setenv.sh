#!/bin/bash

export TF_VAR_tenancy=$(grep tenancy ~/.oci/config | cut -d'=' -f2)
export TF_VAR_compartment=$(oci iam compartment list \
       --query='data[?name==`learning`].{compartment:id}' | \
       jq -r '.[].compartment')

export TF_VAR_ssh_public_key=$(cat "$HOME/.ssh/id_rsa.pub" | tail -n 1)
