output "rds_password" {
  value     = aws_db_instance.rds_mysql.password
  sensitive = true
}
