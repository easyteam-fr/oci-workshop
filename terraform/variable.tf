variable tenancy {}

variable compartment {}

variable instance {
  type = number
  default = 1
}

variable ssh_public_key {
  type        = string
  description = "The local public key"
}
