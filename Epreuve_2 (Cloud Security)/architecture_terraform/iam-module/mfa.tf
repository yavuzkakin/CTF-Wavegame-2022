
# We use a module already implemented to enforce Multi-factor authentication
module enforce_mfa {
  source  = "terraform-module/enforce-mfa/aws"
  version ="0.13.0"

  policy_name                     = "managed-mfa-enforce"
  groups                          = [aws_iam_group.developer.name,aws_iam_group.exploiter.name,aws_iam_group.administrator.name]
  manage_own_signing_certificates  = true
  manage_own_ssh_public_keys      = true
  manage_own_git_credentials      = true
}
