# Variables, output, inferences and dependencies

This section demonstrates several uses of variables, outputs, dependencies and
inferences. It is very useful when creating terraform stacks; some of the
ideas you can pick from here are:

- How to create a VCN, DHCP, Subnet, Security List, Routing Table, Internet Gateway
- How Terraform build the dependencies between resources with the `terraform graph`
- How you can create and delete resources with the various `terraform` commands
- the ability to add an file named `*.auto.tfvars` that is automatically used by
  terraform to populate variables from without having to use the `-var-file`
  parameter
- the fact that when a variable (see `message`) is a map, it can be set from
  different declarations and it results in the addition of all the declared keys
- the ability to create multiple resources from a single declaration with the
  `count` property (see `oci_core_subnet`)
- the ability to use `count.index` to loop through a list
- the use of a function like `lookup` to access a key in a map based on the value
  of a variable
- How you can create a list from a resource that uses `count` with the
  `public_subnets` output

You can move to the next section of this demonstration by running the
command below:

```shell
git checkout -b 04-demo origin/04-demo
```

