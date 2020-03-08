# Dynamic Groups and OCI_CLI_AUTH

The Oracle Linux templates includes a tool called `cloud-init` that can be used
at most Cloud Provider, including OCI. It executes commands at startup from
the metadata property you've added to the instance resource. Among other things,
it set the SSH public keys to the `opc` user so that you can connect when the
instance is started. This 6th part shows how you can use the OCI CLI from an
instance without sharing secrets

## Deploying a dynamic group and its policy

A Dynamic Group is group of resources. It can be used to grant policies to an
instance and avoid sharing keys with it. The `dynamicgroup.tf` file creates
a dynamic group, a policy and a bucket in the test compartment. To create iy,
run the command below:

```shell
terraform apply
```

You should be able to connect to the instance by running the command below:

```shell
IP=$(terraform state show "oci_core_instance.myinstance[0]" | \
  grep "public_ip" | grep -v "assign_public_ip" | cut -d'"' -f2)
ssh opc@$IP
```

## Getting the current compartment

OCI offers an API to get information about the current instance. This API is
also used by `cloud-init` to get its metadata and run the startup commands.
Below is an example of accessing the metadata API to get the current instance
compartment. We assume you've connected to the instance with SSH:

```shell
export COMPARTMENT=$(curl -s http://169.254.169.254/opc/v1/instance/ | \
  jq -r '.compartmentId')
echo $COMPARTMENT
```

## Using the OCI CLI without any secret

If you are connected to the instance that is part of a Dynamic Group and
has a policy set to access some properties, you should be able to use OCI
CLI directly. Just set the `OCI_CLI_AUTH` environment variable like below:

```shell
export OCI_CLI_AUTH=instance_principal
oci os bucket list --compartment-id=$COMPARTMENT \
  --query='data[].{bucket: name}' --output=table
```

You can check you do not have access to other resources like the compute
by running the command below. It should return `404: NotAuthorizedOrNotFound`:

```shell
export OCI_CLI_AUTH=instance_principal
oci compute instance list --compartment-id=$COMPARTMENT
```

## Next section

You can move to the next section of this demonstration by running the
command below:

```shell
git checkout -b 07-demo origin/07-demo
```

