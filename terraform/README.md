# Using Terraform

Retrieve the environment variables specified for Terraform from lastpass, and source the environment file.

To deploy production environment, update the script and run the following:

```bash
cd production/web
terraform init
terraform apply --auto-approve
```