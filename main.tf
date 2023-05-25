terraform {
  required_version = ">= 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.46.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      environment = var.env
      department  = "TPMM"
      application = "HashiCafe website"
    }
  }
}

data "hcp_packer_image" "ubuntu" {
  bucket_name    = var.packer_bucket
  channel        = var.packer_channel
  cloud_provider = "aws"
  region         = var.region
}

resource "aws_security_group" "bastion" {
  name   = "${var.prefix}-bastion-sg"
  vpc_id = aws_vpc.hashidb.id
  tags = {
    Name = "${var.prefix}-bastion-sg"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.hcp_packer_image.ubuntu.cloud_image_id
  instance_type               = var.bastion_instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.hashidb_public.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  user_data                   = <<-EOF
    #!/bin/bash
    export DEBIAN_FRONTEND=noninteractive
    apt-get -qy update
    apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" install postgresql-client
    EOF

  lifecycle {
    postcondition {
      condition     = self.ami == data.hcp_packer_image.ubuntu.cloud_image_id
      error_message = "Must use the latest available AMI, ${data.hcp_packer_image.ubuntu.cloud_image_id}."
    }
    postcondition {
      condition     = self.public_dns != ""
      error_message = "EC2 instance must be in a VPC that has public DNS hostnames enabled."
    }
  }

  tags = {
    Name = "${var.prefix}-hashidb-bastion"
  }
}

resource "aws_security_group" "hashidb" {
  name   = "${var.prefix}-hashidb-sg"
  vpc_id = aws_vpc.hashidb.id
  tags = {
    Name = "${var.prefix}-hashidb-sg"
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.address_space]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_rds_engine_version" "selected" {
  engine = "postgres"
}

resource "aws_db_subnet_group" "hashidb" {
  name       = "${var.prefix}-hashidb-subnet-group"
  subnet_ids = [aws_subnet.hashidb_private_primary.id, aws_subnet.hashidb_private_secondary.id]

  tags = {
    Name = "${var.prefix}-hashidb-subnet-group"
  }
}

resource "aws_db_instance" "hashidb" {
  identifier             = "${var.prefix}-hashidb"
  availability_zone      = aws_subnet.hashidb_private_primary.availability_zone
  allocated_storage      = 20
  max_allocated_storage  = 100
  storage_type           = "gp2"
  db_name                = var.db_name
  engine                 = "postgres"
  engine_version         = data.aws_rds_engine_version.selected.version
  instance_class         = var.db_instance_type
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.hashidb.name
  storage_encrypted      = true
  apply_immediately      = true
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.hashidb.id]
  tags = {
    "key" = "value"
  }

  lifecycle {
    postcondition {
      condition     = self.status != "available"
      error_message = "The DB instance status must be 'available'."
    }
    postcondition {
      condition     = self.publicly_accessible == false
      error_message = "The DB instance must not be publicly accessible."
    }
    postcondition {
      condition     = self.allocated_storage >= 20
      error_message = "The minimum DB size is 20 GB."
    }
  }
}
