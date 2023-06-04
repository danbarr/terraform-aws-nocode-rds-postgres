data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "hashidb" {
  cidr_block           = var.address_space
  enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix}-rds-vpc-${var.region}"
  }
}

resource "aws_subnet" "hashidb_public" {
  vpc_id            = aws_vpc.hashidb.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.prefix}-rds-public-subnet"
  }
}

resource "aws_subnet" "hashidb_private_primary" {
  vpc_id            = aws_vpc.hashidb.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = var.private_subnet_cidr_primary

  tags = {
    Name = "${var.prefix}-rds-private-subnet-primary"
  }
}

resource "aws_subnet" "hashidb_private_secondary" {
  vpc_id            = aws_vpc.hashidb.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block        = var.private_subnet_cidr_secondary

  tags = {
    Name = "${var.prefix}-rds-private-subnet-secondary"
  }
}

resource "aws_internet_gateway" "hashidb" {
  vpc_id = aws_vpc.hashidb.id

  tags = {
    Name = "${var.prefix}-internet-gateway"
  }
}

resource "aws_route_table" "hashidb_public" {
  vpc_id = aws_vpc.hashidb.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hashidb.id
  }
}

resource "aws_route_table_association" "hashidb" {
  subnet_id      = aws_subnet.hashidb_public.id
  route_table_id = aws_route_table.hashidb_public.id
}

