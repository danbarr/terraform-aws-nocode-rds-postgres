# Terraform module aws-nocode-rds-postgres

Provisions a PostgreSQL RDS instance in AWS with an EC2 bastion host.

Enabled for Terraform Cloud [no-code provisioning](https://developer.hashicorp.com/terraform/cloud-docs/no-code-provisioning/module-design).

For no-code provisioning, AWS credentials must be supplied to the workspace via environment variables (e.g. `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`). Also requires HCP connection credentials (`HCP_CLIENT_ID` and `HCP_CLIENT_SECRET`).
