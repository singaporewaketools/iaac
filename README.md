# Terraform based infrastructure

NOTE: some private data not commited to this repo:

create `live/main/common_secret_vars.yaml`

```
billing_subscriptions:
  id: 
    protocol: "sms"
    endpoint: "+65<redacted>"
```

This repository follows the Terragrunt layout to manage state while keeping the TF code DRY.

```
$ tree -L 3
.
├── live
│   ├── main
│   │   ├── terragrunt.hcl
│   │   ├── common_vars.yaml
│   │   ├── account-base
└── modules
    ├── README.md
    ├── basic
    │   ├── README.md
    │   ├── private-subnets
    │   ├── public-subnets
    │   ├── s3-bucket-simple
    │   ├── ssh-key
    │   └── vpc
    └── composed
        ├── README.md
        └── account-base
```

## Why Terragrunt?

- Automatically initializes state S3 buckets with versioning, encryption and DynamoDb state locks
- Handles state transparently across configuration code
- Handles inheritance of environment settings across infrastructure layers
- Handles cross layer dependencies and parameter passing

## CIDR Overview

This is not automated yet, ideally we move to something like [go-jek/gana](https://blog.gojekengineering.com/gana-a-solution-to-keep-up-with-scale-e4bbe7561960)

For now:

```
 for n in $(find . -type d -name network-* -not -path "*/.terragrunt-cache/*");do echo $n;grep '  cidr_block = "' $n/terragrunt.hcl;done
./live/main/network-prod
  cidr_block = "10.50.0.0/20"
```

## Terraform set up

Currently using TF 0.12.16

OSX Set up:

```
curl -Lo tf.zip https://releases.hashicorp.com/terraform/0.12.16/terraform_0.12.16_darwin_amd64.zip
unzip tf.zip && rm tf.zip
sudo mv terraform /usr/local/bin/
```


## Terragrunt set up

```
curl -Lo terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.21.2/terragrunt_darwin_amd64
chmod +x terragrunt && mv /usr/local/bin/
```

## Custom providers set up

### terraform-provider-filesystem

- Download the compiled binary for Terraform 0.12 from [GitHub releases][https://github.com/sethvargo/terraform-provider-filesystem/releases].

- Unzip/untar the archive.

- Move it into `$HOME/.terraform.d/plugins`:

```sh
# OSX download one-liner
$ curl -L https://github.com/sethvargo/terraform-provider-filesystem/releases/download/v0.1.1/darwin_amd64.tgz | tar -xzf -

$ mkdir -p $HOME/.terraform.d/plugins
$ mv terraform-provider-filesystem $HOME/.terraform.d/plugins/terraform-provider-filesystem
```

- Create your Terraform configurations as normal, and run `terraform init`:

```sh
$ terraform init
```

### terraform-provider-kops

- Download the compiled binary for Terraform 0.12 from [GitHub releases](https://github.com/compareasiagroup/terraform-provider-kops/releases/tag/0.1.0)

- Unzip/untar the archive

- Move it into `$HOME/.terraform.d/plugins`:

```sh
$ curl -L https://github.com/compareasiagroup/terraform-provider-kops/releases/download/0.1.0/terraform-provider-kops_0.1.0_darwin_amd64.tgz | tar -xzf -

$ mkdir -p $HOME/.terraform.d/plugins
$ mv terraform-provider-kops $HOME/.terraform.d/plugins/terraform-provider-kops
```

- Create your Terraform configurations as normal, and run `terraform init`:

```sh
terraform init
```
