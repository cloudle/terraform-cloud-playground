data "aws_iam_policy_document" "sns-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["cognito-idp.amazonaws.com"]
      type        = "Service"
    }

    condition {
      test     = "StringEquals"
      values   = [var.snsExternalId]
      variable = "sts:ExternalId"
    }
  }
}

data "aws_iam_policy_document" "identity-pool-assume-role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      values   = [aws_cognito_identity_pool.main.id]
      variable = "cognito-identity.amazonaws.com:aud"
    }

    condition {
      test     = "ForAnyValue:StringLike"
      values   = ["authenticated"]
      variable = "cognito-identity.amazonaws.com:amr"
    }
  }
}

data "aws_iam_policy_document" "cognito-authenticated" {
  statement {
    actions = [
      "mobileanalytics:PutEvents",
      "cognito-sync:*",
      "cognito-identity:*",
    ]
    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "sns" {
  statement {
    actions = [
      "sns:Publish",
    ]
    resources = [
      "*",
    ]
  }
}
