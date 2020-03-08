# Use Packer

Packer is a popular tool by Hashicorp to build instance images. It allows to
prepare artifacts and start them quickly.

## Installing Packer

Start by installing packer. It can be downloaded from 
[Packer Download Page](https://www.packer.io/downloads.html); Below is an
example of installation on Linux. It can be easily adapted for Mac or Windows:

```shell
cd /tmp
export PACKER_VERSION=1.5.4
curl -L -O "https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_${PACKER_VERSION}_linux_amd64.zip"
cd /usr/local/bin
sudo unzip /tmp/packer_${PACKER_VERSION}_linux_amd64.zip
sudo chmod a+x /usr/local/bin/packer
alias packer=/usr/local/bin/packer
```

## Finding the latest Oracle Linux Image

The command below searches the 2 latest Oracle Linux 7.7 images; It can be
used to create the packer template:

```shell
for i in $(oci compute image list \
  --query="data[? (\"operating-system-version\" == '7.7' && \"operating-system\" == 'Oracle Linux')]" \
  --compartment-id=$TF_VAR_tenancy \
  | jq ".[] | {name:.\"display-name\",id:.id,created:.\"time-created\"}" \
  | jq -r '"\(.created);\(.id);\(.name)"' \
  | sort | tail -n 2); do
  name=$(echo "$i"| cut -d';' -f3)
  id=$(echo "$i"| cut -d';' -f2)
  printf "%-50s %s\n" "$name" "$id"
done
```

## Subnet and Compartment

Assuming you've applied the terraform stack, you should be able to get the
compartment by running the command below:

```shell
. ./terraform/setenv.sh
echo $TF_VAR_compartment
```

You should be able to get the subnet by running the command below:

```shell
cd terraform
export SUBNET=$(terraform state show \
  "module.livecode.oci_core_subnet.public_subnet[0]" \
  | grep "ocid1.subnet" | cut -d'"' -f2)
echo $SUBNET
```

## Building an OCI image

> Note: before you proceed, run `terraform apply` to add the right security list
> to the VCN so that `packer` can update the instance with the yum repository

We've created a `template.json` file as well as a `install.sh` script in the
`packer` directory. To build the image, check the availability domain is
correct with the command below

```shell
oci iam availability-domain list
```

Run the command below, to create a new image:

```shell
cd packer
packer build -var "subnet=$SUBNET" \
  -var "compartment=$TF_VAR_compartment" \
  template.json
```

## Deploying the OCI image

We've created an instance from the Packer image in the `instance.tf` file in
the `terraform` directory. To deploy it, run the following:

```shell
cd terraform
export TF_VAR_instance=1
terraform init
terraform apply
```

You should get the IP address from the outputs. You can test the associated
web server from your browser

You can move to the next section of this demonstration by running the
command below:

```shell
git checkout -b 06-demo origin/06-demo
```

