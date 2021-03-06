data oci_identity_availability_domains primary_availability_domains {
  compartment_id = var.compartment
}

resource oci_core_vcn main {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment
  dns_label      = var.name
  display_name   = var.name
  freeform_tags = {
    "User"        = "Gregory"
    "Environment" = var.environment
  }
}

resource "oci_core_dhcp_options" "DhcpOptions" {
  compartment_id = var.compartment
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${oci_core_vcn.main.display_name}_dhcp_options"

  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  options {
    type                = "SearchDomain"
    search_domain_names = ["${oci_core_vcn.main.display_name}.oraclevcn.com"]
  }
}

resource "oci_core_internet_gateway" "internetgateway" {
  compartment_id = var.compartment
  display_name   = "${oci_core_vcn.main.display_name}-igw"
  vcn_id         = oci_core_vcn.main.id
}
