output "password" {
  value = aws_secretsmanager_secret_version.credentials.secret_string
}