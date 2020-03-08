# Managing Terraform State on a bucket

Terraform state is very important! It is used behind the scene to track
your provider resource internal identifier and how they are linked to the
project resources. At the beginning of this part, you should have a file
`terraform.tfstate` in your `terraform` directory that is the current state.

This file should not be considered as part of the project. The reason is your
code could have N representations: 

- One on production
- One on staging
- ...

In this section, you will pushing that file on an OCI bucket and referencing
it as your terraform back-end.

## Create a bucket for your state

There are 2 ways to secure the terraform state for OCI. You can rely on the HTTP
backend or use the S3-compatible backend. The later configuration allows to use
different workspaces and, you might prefer to rely on it. To begin, create a bucket
that you know to be unique. You can use your company domain name to help with
the unicity like below:

- name a unique bucket

```shell
export BUCKET=learning-terraform.easyteam.fr
```

- Create the bucket in the compartment you have created in the previous part

```shell
oci os bucket create \
  --compartment-id=${TF_VAR_compartment} \
  --public-access-type NoPublicAccess \
  --name ${BUCKET}

export NAMESPACE=$(oci os bucket list \
  --compartment-id=${TF_VAR_compartment} \
  --query='data[?name==`'$BUCKET'`].{namespace:namespace}' | \
  jq -r '.[].namespace')

echo $NAMESPACE
```

## Create an access/secret key

You can use the `oci` CLI to create the access/secret keys for the S3
compatible bucket. In order to proceed, set your username in the `ACCOUNT`
variable and run the set of commands below:

```shell
export ACCOUNT="oracleidentitycloudservice/username"
export TF_VAR_userid=$(oci iam user list \
  --query='data[?name==`'$ACCOUNT'`].{user:id}' | \
  jq -r '.[].user')
echo $TF_VAR_userid

oci iam customer-secret-key create --display-name terraform \
  --user-id=$TF_VAR_userid
```

Once done, you can add the `id` and `key` returned by the create command in the
`~/.aws/credentials` file like below

```text
[oci]
aws_access_key_id = <id value>
aws_secret_access_key = <key value>
```

To test your keys, install the AWS CLI and get your account namespace with the
command below:

```shell
export NAMESPACE=$(oci os ns get | jq -r '.data')
export REGION=eu-frankfurt-1
```

You should be able to list the buckets by running the command below:

```shell
aws s3api list-buckets --profile=oci \
  --endpoint-url=https://${NAMESPACE}.compat.objectstorage.${REGION}.oraclecloud.com
```

## Configure the backend

To configure the backend, create a file `backend.tf` with the content below:

```text
terraform {
  backend "s3" {
    profile  = "{PROFILE}"
    bucket   = "{BUCKET}"
    key      = "terraform.tfstate"
    region   = "{REGION}"
    endpoint = "https://{NAMESPACE}.compat.objectstorage.{REGION}.oraclecloud.com"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
```

Replace `{PROFILE}`, `{BUCKET}`, `{REGION}` and `{NAMESPACE}` to meet your
configuration. You should be able to add the file to your project by changing
the `.gitignore` file.

## Upload the current state to the backend

By running `terraform init` again, you will be asked to upload the current
state to the bucket. Answer `yes` like below:

```text
terraform init

Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "s3" backend. No existing state was found in the newly
  configured "s3" backend. Do you want to copy this state to the new "s3"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes


Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.oci: version = "~> 3.65"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

# Re-initialize your project

Once done, you can re-initialize your project state and verify you can now
access the remote state:

```shell
# Remove the local state and configuration
cd terraform
rm -rf .terraform terraform.tfstate*

# Initialize the state from the `backend.tf` file
terraform init

# Verify the state is used
terraform state list
```

You can move to the next section of this demonstration by running the
command below:

```shell
git checkout -b 03-demo origin/03-demo
```
