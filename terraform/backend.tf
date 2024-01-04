terraform {
  backend "s3" {
    bucket = "demo-terraform-state-s3"
    key = "tf/terraform.tfstate"
    region = "us-east-1"
    profile = "terraform-user"
  }
}