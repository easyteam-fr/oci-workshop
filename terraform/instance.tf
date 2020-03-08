data oci_identity_availability_domains primary_availability_domains {
   compartment_id = var.compartment
}

data "oci_core_images" "myimage" {
  #Required
  compartment_id = "${var.compartment}"

  #Optional
  display_name = "LiveCode"
}

resource "oci_core_instance" "myinstance" {
  count = var.instance
  availability_domain = lookup(data.oci_identity_availability_domains.primary_availability_domains.availability_domains[0],"name")
  compartment_id      = var.compartment
  display_name        = "livecode-instance"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.myimage.images.0.id
  }

  shape = "VM.Standard2.1"

  create_vnic_details {
    subnet_id              = module.livecode.public_subnets[0]
    skip_source_dest_check = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file("${path.module}/instance.tpl"))
  }
}

data "oci_core_vnic_attachments" "myinstancevnic" {
  count = var.instance
  compartment_id      = var.compartment
  availability_domain = lookup(data.oci_identity_availability_domains.primary_availability_domains.availability_domains[0],"name")
  instance_id         = oci_core_instance.myinstance[count.index].id
}

data "oci_core_vnic" "myinstancevnic" {
  count = var.instance
  vnic_id = lookup(data.oci_core_vnic_attachments.myinstancevnic[count.index].vnic_attachments[0],"vnic_id")
}

data "oci_core_private_ips" "myprivateip" {
  count = var.instance
  vnic_id = "${data.oci_core_vnic.myinstancevnic[count.index].id}"
}

data "oci_core_public_ips" "mypublicips" {
  count = var.instance
  compartment_id      = var.compartment
  scope               = "AVAILABILITY_DOMAIN"
  availability_domain = lookup(data.oci_identity_availability_domains.primary_availability_domains.availability_domains[0],"name")
  
  filter {
    name = "private_ip_id"
    values = ["${lookup(data.oci_core_private_ips.myprivateip[count.index].private_ips[0], "id")}"]
  }
}

output livecode_url {
  value = "http://${lookup(data.oci_core_public_ips.mypublicips[0].public_ips[0], "ip_address")}"
}

