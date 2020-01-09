resource "aws_cloudwatch_metric_alarm" "account_billing" {
  provider            = aws.billing
  alarm_name          = "account-billing-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"     # every 6 hours
  period              = "21600" # The period in seconds ~ 6 hours
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  statistic           = "Average"
  threshold           = var.billing_threshhold
  alarm_description   = "Billing alarm by account"
  alarm_actions       = [aws_sns_topic.billing_alerts.arn]

  dimensions = {
    Currency      = "USD"
    LinkedAccount = data.aws_caller_identity.current.account_id
  }
}

resource "aws_sns_topic" "billing_alerts" {
  provider = aws.billing
  name     = "${local.id}-billing-alerts"

  tags = merge(
    local.tags,
    map(
      "Name", "${local.id}-billing-alerts"
    )
  )
}

resource "aws_sns_topic_subscription" "billing_alerts" {
  for_each = var.billing_subscriptions
  provider  = aws.billing
  topic_arn = aws_sns_topic.billing_alerts.arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
}

## Billing IAM
# give AWS Budgets permissions to publish to billing_alerts sns topic
resource "aws_sns_topic_policy" "billing_alerts" {
  provider = aws.billing
  arn      = aws_sns_topic.billing_alerts.arn
  policy   = data.aws_iam_policy_document.sns_billing_alerts.json
}

data "aws_iam_policy_document" "sns_billing_alerts" {
  provider = aws.billing
  policy_id = "__default_policy_ID"

  statement {
    sid = "AWSBudgetsAlerts"

    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }
    actions = [
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.billing_alerts.arn,
    ]
  }

  statement {
    sid = "__default_statement_ID"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }

    resources = [
      aws_sns_topic.billing_alerts.arn,
    ]
  }
}
