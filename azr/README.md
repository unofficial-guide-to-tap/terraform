# TAP on GCP

## Usage

1. Create a `Service Principal` according to [this link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret


2. Edit the variables for this Terraform project
```
cp variables.tfvars_example variables.tfvars
vim variables.tfvars
```

3. Run Terraform
```
export ARM_CLIENT_ID="..."
export ARM_CLIENT_SECRET="..."
export ARM_TENANT_ID="..."
export ARM_SUBSCRIPTION_ID="..."

terraform init -backend-config=backend.config -var-file="variables.tfvars"
terraform apply -var-file="variables.tfvars"
```
---

3. SSH to Jumphost
```
JH_USER=$(terraform output jumphost_user)
JH_ADDR=$(terraform output jumphost_address)
ssh $JH_USER@$JH_ADDR
```

## Hints

* Recreate the cluster

  ```
  terraform apply -var-file="variables.tfvars" \
    -replace "google_container_cluster.cluster[0]" \
    -replace "google_container_node_pool.pool[0]"
  ```
