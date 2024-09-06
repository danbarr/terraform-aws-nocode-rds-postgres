# Terraform module aws-nocode-rds-postgres

Provisions an AWS VPC with a PostgreSQL RDS instance and an EC2 bastion host. The bastion uses a base AMI registered in [HCP Packer](https://www.hashicorp.com/products/packer).

Enabled for Terraform Cloud [no-code provisioning](https://developer.hashicorp.com/terraform/cloud-docs/no-code-provisioning/module-design).

## Prerequisites

For no-code provisioning, AWS credentials must be supplied to the workspace via environment variables (e.g. `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) or using [dynamic provider credentials](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials).

Also requires environment variables containing an HCP service principal credential (`HCP_CLIENT_ID` and `HCP_CLIENT_SECRET`). It is recommende to attach these globally or to projects where no-code workspaces will be provisioned.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | ~> 0.82 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | ~> 0.82 |

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.hashidb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.hashidb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.hashidb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route_table.hashidb_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.hashidb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.hashidb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.hashidb_private_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.hashidb_private_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.hashidb_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.hashidb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_rds_engine_version.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |
| [hcp_packer_artifact.ubuntu](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/packer_artifact) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Password for the DB admin. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Value for the environment tag. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | This prefix will be included in the name of most resources. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where the resources are created. | `string` | n/a | yes |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | The address space that is used by the VPC. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_bastion_instance_type"></a> [bastion\_instance\_type](#input\_bastion\_instance\_type) | Specifies the EC2 instance type for the bastion host. | `string` | `"t3.micro"` | no |
| <a name="input_db_instance_type"></a> [db\_instance\_type](#input\_db\_instance\_type) | Specifies the RDS instance type. | `string` | `"db.t4g.micro"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Name of the initial database. | `string` | `"hashicafe"` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | The DB admin username. | `string` | `"postgres"` | no |
| <a name="input_department"></a> [department](#input\_department) | Value for the department tag. | `string` | `"DBA"` | no |
| <a name="input_packer_bucket"></a> [packer\_bucket](#input\_packer\_bucket) | HCP Packer image bucket name for the bastion instance. | `string` | `"ubuntu22-base"` | no |
| <a name="input_packer_channel"></a> [packer\_channel](#input\_packer\_channel) | HCP Packer image channel. | `string` | `"production"` | no |
| <a name="input_private_subnet_cidr_primary"></a> [private\_subnet\_cidr\_primary](#input\_private\_subnet\_cidr\_primary) | The address prefix to use for the primary private subnet. | `string` | `"10.0.20.0/24"` | no |
| <a name="input_private_subnet_cidr_secondary"></a> [private\_subnet\_cidr\_secondary](#input\_private\_subnet\_cidr\_secondary) | The address prefix to use for the secondary private subnet. | `string` | `"10.0.21.0/24"` | no |
| <a name="input_public_subnet_cidr"></a> [public\_subnet\_cidr](#input\_public\_subnet\_cidr) | The address prefix to use for the public subnet. | `string` | `"10.0.10.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_ip"></a> [bastion\_ip](#output\_bastion\_ip) | IP address of the bastion host. |
| <a name="output_db_endpoint"></a> [db\_endpoint](#output\_db\_endpoint) | Endpoint of the database instance. |
| <a name="output_db_name"></a> [db\_name](#output\_db\_name) | Name of the initial database. |
| <a name="output_db_username"></a> [db\_username](#output\_db\_username) | Username of the DB admin. |
| <a name="output_db_version"></a> [db\_version](#output\_db\_version) | Version of the DB engine. |
<!-- END_TF_DOCS -->