
#declaration of the developer IAM group
resource aws_iam_group developer {
  name =  "developer"
  path = "/users/"
}


# developer group permission policy
resource "aws_iam_group_policy" "developer_policy" {
  name  = "my_developer_policy"
  group = aws_iam_group.developer.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
          "rds:Describe*",
          "iam:ChangePassword"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

#declaration of the exploiter IAM group
resource aws_iam_group exploiter {
  name =  "exploiter"
  path = "/users/"
}

# exploiter group permission policy
resource "aws_iam_group_policy" "exploiter_policy" {
  name  = "exploiter_policy"
  group = aws_iam_group.exploiter.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
          "rds:*",
          "iam:ChangePassword"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


#declaration of the administrator IAM group
resource aws_iam_group administrator {
  name =  "administrator"
}


# administrator group permission policy
resource "aws_iam_group_policy" "administrator_policy" {
  name  = "administrator_policy"
  group = aws_iam_group.administrator.name

  policy = jsonencode({
    Version = "2012-10-17"

# in the first statement, we allow everything, regarding ec2, rds, and iam
    Statement = [
      {
        Action = ["ec2:*","rds:*","iam:*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]

# in the second statement, we deny the permissions, for password change , ...
    Statement = [
      {
        Action = ["iam:ChangePassword",
          "iam:CreatePolicy",
          "iam:*Delete*",
          "iam:*Create*",
          "iam:GetLoginProfile",
          "iam:*Update*"

        ]
        Effect   = "Deny"
        Resource = "*"
      },
    ]
  })
}
