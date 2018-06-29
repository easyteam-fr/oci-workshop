#!/bin/bash

export TF_VAR_tenancy=$(grep tenancy ~/.oci/config | cut -d'=' -f2)
export TF_VAR_compartment=$(oci iam compartment list \
       --query='data[?name==`learning`].{compartment:id}' | \
       jq -r '.[].compartment')

