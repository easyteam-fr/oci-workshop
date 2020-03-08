# Modules

Modules are first class citizens in terraform. They are easy to write and use
and can be referenced from the code but also from git repositories or from
[https://registry.terraform.io](https://registry.terraform.io). This part
demonstrates how to move from a set of resources into a module:

- create a new stack, here `modules/public-network` and move all the
  resources into it.
- remove these same resources from the original `terraform` directory.
- in the module, for each value that cannot be accessed, directly from it,
  create a variable, for instance, create a variable for the `compartment`
- if you want to use other parameter, like naming the module, add
  additional variables
- if you need the module to provide outputs, like the subnet identifiers,
  add an output to export them
- in the main project, reference the module with the module directory as
  as `source` like below:

```hcl
module "livecode" {
  compartment = "${var.compartment}"
  name = "livecode"
  source = "../modules/public-network"
}
```

- if you need to access some module output, just reference them by their name
  like `module.livecode.public_subnets` in this case.
- to use the module, you should run `terraform init` again. Once done, you can
  simply `apply` or `destroy` the module.

You can move to the next section of this demonstration by running the
command below:

```shell
git checkout -b 05-demo origin/05-demo
```

