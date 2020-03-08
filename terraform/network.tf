module livecode {
  compartment = var.compartment
  name = "livecode"
  source = "../modules/public-network"
}

module developer {
  compartment = var.compartment
  name = "developer"
  source = "github.com/easyteam-fr/oci-workshop?ref=04-demo//modules/public-network"
}

output livecode_subnets {
  value = "${module.livecode.public_subnets}"
}
