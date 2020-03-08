#!/usr/bin/env bash

set -e

version() {
  git tag -l --merged HEAD --sort=-creatordate "$1@*" | head -1 | cut -d'@' -f2
}

OCI_WORKSHOP=$(version oci-workshop)

jq -n \
  --arg oci_workshop "$OCI_WORKSHOP" \
  '{ "oci-workshop": $oci_workshop }'
