################# For B2 #############################################
resource "aws_budgets_budget_action" "B2" {
  budget_name        = "budget-B2"
  action_type        = "APPLY_IAM_POLICY"
  approval_model     = "AUTOMATIC"
  notification_type  = "ACTUAL"
  execution_role_arn = aws_iam_role.budget_iam_role.arn

  action_threshold {
    action_threshold_type  = "PERCENTAGE"
    action_threshold_value = 100
  }

  definition {
    iam_action_definition {
      policy_arn = aws_iam_policy.budget_iam_policy.arn
      roles      = [aws_iam_role.budget_iam_role.name]
    }
  }
  subscriber {
    address           = "chreim@eurecom.fr"
    subscription_type = "EMAIL"
  }
}

resource "aws_iam_policy" "budget_iam_policy" {
  name        = "budget_iam_policy"
  description = "Noops budget IAM policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "s3:Describe*",
        "lambda:Describe*"
      ],
      "Effect": "Deny",
      "Resource": "*"
    }
  ]
}
EOF
}

data "aws_partition" "current" {}

resource "aws_iam_role" "budget_iam_role" {
  name = "budget_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "budgets.${data.aws_partition.current.dns_suffix}"
        ]
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ]
}
EOF
}

resource "aws_budgets_budget" "budget_B2" {
  name              = "budget-B2"
  budget_type       = "USAGE"
  limit_amount      = "25"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
}

######################################## B1 #############################3
resource "aws_budgets_budget" "budget_alerting" {
  name              = "budget-alerting"
  budget_type       = "COST"
  limit_amount      = "25"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 50
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["akin@eurecom.fr"]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 90
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["akin@eurecom.fr"]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["akin@eurecom.fr"]
  }
}

