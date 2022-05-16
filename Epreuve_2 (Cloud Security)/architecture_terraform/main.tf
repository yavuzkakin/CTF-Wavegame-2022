# When you declare a variable in child modules, the calling module should pass values in the module block as an input.

# SCP : module to manage SCP
module "scp" {
  source = "./scp-module"

  scp_bucket_id = var.scp_bucket_id
}

# IAM : user and access management resources
module "iam" {
  source = "./iam-module"
}

# COMPUTE : computing resources
module "compute" {
  source = "./compute-module"
}
