resource "aws_secretsmanager_secret" "secret" {
  name        = "sm-${local.name}-${var.environment}"
  description = "Secrets for my application"
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode({
    rds_password = module.database.rds_password
  })
}