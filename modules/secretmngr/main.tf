resource "aws_secretsmanager_secret" "credentials" {
  name = var.name
  tags = {
    Name = "rds-pass"
    }
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "credentials" {
  secret_id     = aws_secretsmanager_secret.credentials.id
  secret_string = var.secret_string
}