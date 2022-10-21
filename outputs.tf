output "bastion_ip" {
  description = "IP address of the bastion host."
  value       = aws_instance.bastion.public_ip
}

output "db_endpoint" {
  description = "Endpoint of the database instance."
  value       = aws_db_instance.hashidb.endpoint
}

output "db_name" {
  description = "Name of the initial database."
  value = aws_db_instance.hashidb.db_name
}

output "db_username" {
  description = "Username of the DB admin."
  value       = aws_db_instance.hashidb.username
}

output "db_version" {
  description = "Version of the DB engine."
  value       = data.aws_rds_engine_version.selected.version
}
