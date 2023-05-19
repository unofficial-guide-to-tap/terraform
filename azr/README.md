# TAP on Azure

To authenticate Terraform, we use a *Service Principal* with a *Client Secret*. Check [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret) for instructions.

## Usage

1. Edit the variables for this Terraform project
```
cp variables.tfvars_example variables.tfvars
vim variables.tfvars
```

2. Run Terraform
```
export ARM_CLIENT_ID="..."
export ARM_CLIENT_SECRET="..."
export ARM_TENANT_ID="..."
export ARM_SUBSCRIPTION_ID="..."

terraform init -backend-config=backend.config -var-file="variables.tfvars"
terraform apply -var-file="variables.tfvars"
```

3. SSH to Jumphost
```
JH_USER=$(terraform output jumphost_user)
JH_ADDR=$(terraform output jumphost_address)
ssh $JH_USER@$JH_ADDR
```
