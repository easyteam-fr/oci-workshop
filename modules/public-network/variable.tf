variable "name" {
  type = string
  description = "the VCN name"
  default = "livecode"
}

variable "compartment" {}

variable environment {
  type        = string
  description = "The environment name"
  default     = "learning"
}

variable message {
  type        = map
  description = "The environment name"
  default = {
    learning   = "Welcome to the learning environment"
    production = "Welcome to the production environment"
  }
}

