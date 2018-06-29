provider "oci" {
  tenancy_ocid         = "${var.tenancy}"
  user_ocid            = "${var.user}"
  fingerprint          = "${var.fingerprint}"
  private_key_path     = "${var.key_file}"
  region               = "${var.region}"
  disable_auto_retries = "true"
}

variable "tenancy" {}
variable "user" {}
variable "fingerprint" {}
variable "key_file" {}
variable "region" {}
