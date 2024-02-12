terraform {
  backend "s3" {
    bucket         = "statefile-bkp24"
    key            = "newinfra/terraform.tfstate"
    encrypt        = true
    region         = "us-east-1"
  }
}