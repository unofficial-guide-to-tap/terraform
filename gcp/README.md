# TAP on GCP

1. Create and configure `variables.tfvars`
```
cp variables.tfvars_example variables.tfvars
vim variables.tfvars
```

2. Run Terraform
```
terraform init -backend-config=backend.config -var-file="variables.tfvars"
terraform apply -var-file="variables.tfvars"
```

3. SSH to Jumphost
```
JH_USER=$(terraform output jumphost_user)
JH_ADDR=$(terraform output jumphost_address)

# Make sure your public key is loaded into ssh-agent
ssh $JH_USER@$JH_ADDR
```

