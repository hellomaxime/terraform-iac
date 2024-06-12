terraform {
  backend "s3" {
    encrypt = true
    bucket = "backend-bucket119298307439258"
    dynamodb_table = "dynamodb-terraform-state-lock"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}