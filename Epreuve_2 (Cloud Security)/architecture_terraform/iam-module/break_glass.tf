resource "aws_iam_user" "breakglass" {
  name = "breakglass"
}

resource "aws_iam_user_policy" "breakglass_policy"{
  name="breakglass_policy"
  user=aws_iam_user.breakglass.name
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "kms:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}
