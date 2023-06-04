variable "prefix" {
  type        = string
  description = "This prefix will be included in the name of most resources."
}

variable "region" {
  type        = string
  description = "The region where the resources are created."
}

variable "env" {
  type        = string
  description = "Value for the environment tag."
}

variable "department" {
  type        = string
  description = "Value for the department tag."
  default     = "DBA"
}

variable "address_space" {
  type        = string
  description = "The address space that is used by the VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "The address prefix to use for the public subnet."
  default     = "10.0.10.0/24"
}

variable "private_subnet_cidr_primary" {
  type        = string
  description = "The address prefix to use for the primary private subnet."
  default     = "10.0.20.0/24"
}

variable "private_subnet_cidr_secondary" {
  type        = string
  description = "The address prefix to use for the secondary private subnet."
  default     = "10.0.21.0/24"
}

variable "packer_bucket" {
  type        = string
  description = "HCP Packer image bucket name for the bastion instance."
  default     = "ubuntu22-base"
}

variable "packer_channel" {
  type        = string
  description = "HCP Packer image channel."
  default     = "production"
}

variable "bastion_instance_type" {
  type        = string
  description = "Specifies the EC2 instance type for the bastion host."
  default     = "t3.micro"
}

variable "db_instance_type" {
  type        = string
  description = "Specifies the RDS instance type."
  default     = "db.t4g.micro"
}

variable "db_name" {
  type        = string
  description = "Name of the initial database."
  default     = "hashicafe"
}

variable "db_username" {
  type        = string
  description = "The DB admin username."
  default     = "postgres"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Password for the DB admin."
}
