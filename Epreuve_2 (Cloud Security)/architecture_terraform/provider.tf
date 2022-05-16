terraform {
  required_version = ">=0.13.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"  # we modified the version so that we can use module db in main.tf
    }
  }
  # -- Remote Backend if you want to work in collaboration --
  # backend "s3" {
  #   bucket = "YOUR_OWN_BUCKET"
  #   key    = "TF_STATE_KEY"
  #   region = "REGION"
  #   profile = "PROFILE"
  # }
}

# Configure the AWS Provider with the account used to build the AWS resources
provider "aws" {
  region  = "eu-west-3"
  profile = "default"
}

########################################## CN1 ###############################################
resource "aws_instance" "prod" {
  ami           = "ami-0c6ebbd55ab05f070"
  instance_type = "t2.micro"
  tags = {
    "env"="prod",
    "métier"="streaming"
  }
}
