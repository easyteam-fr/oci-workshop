data "external" "version" {
  program = ["${path.module}/version.sh"]

  query = {
    workspace = "${terraform.workspace}"
  }
}

output "oci-workshop" {
  value = "${lookup(data.external.version.result, "oci-workshop")}"
}
