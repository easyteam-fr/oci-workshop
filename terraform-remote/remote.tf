data "terraform_remote_state" "terraform" {
  backend = "s3"
  config = {
    profile  = "oci"
    bucket   = "learning-terraform.easyteam.fr"
    key      = "terraform.tfstate"
    region   = "eu-frankfurt-1"
    endpoint = "https://frovdc5xjc1o.compat.objectstorage.eu-frankfurt-1.oraclecloud.com"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}

output "livecode_url" {
  value = "${data.terraform_remote_state.terraform.outputs.livecode_url}"
}
