# Managing Secrets

Managing secrets is a key point when working with code. The best way to do it
is probably by configuring [Vault](https://www.vaultproject.io/). However for
a quick setup, you can rely on a bucket like below:

## Create secrets that are not part of the project

We've created a directory as part of the project and added a `.gitignore` file
so that no files can be pushed to the origin. Once done, we can create our
secret files:

```shell
cd secrets
echo '{ "key1": "secret"}' >secret.json
```

## Push secrets to a bucket

To start, push the secret to a bucket:

```shell
terraform state list
export BUCKET=$(terraform state show oci_objectstorage_bucket.backup_bucket | \
  grep "name" | grep -v "namespace" | cut -d'"' -f2)

oci os object put --bucket-name $BUCKET \
  --file=secret.json --name=/configuration/secret/secret.json
```

> Note: You should remove the files from your laptop for more security

## Add a startup script that pull secrets from the bucket at startup

Once done, you could add a script that load the secrets as part of the instance
startup process. It has been added to the `instance.tpl` script. Once restarted,
the instance has access to its secrets. You can connect and check it.

# Destroy your stack

To finish the workshop, destroy the whole stack:

```shell
cd terraform
terraform destroy
```

## Next section

You can move to the next section of this demonstration by running the
command below:

```shell
git checkout -b oraclecode origin/oraclecode
```

