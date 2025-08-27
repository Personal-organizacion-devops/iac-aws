resource "aws_secretsmanager_secret" "secret" {
  name                    = "sm-${local.name}-secrets-${var.environment}"
  description             = "Secrets for my application"
  recovery_window_in_days = 0 # Elimina inmediatamente al hacer destroy
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode({
    rds_password = module.database.rds_password
  })
}