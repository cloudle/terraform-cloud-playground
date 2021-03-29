resource "aws_iam_role" "cognito-identified" {
  name = "${var.systemName}-identified-cognito"
  assume_role_policy = data.aws_iam_policy_document.identity-pool-assume-role.json
}

resource "aws_iam_role" "cognito-anonymous" {
  name = "${var.systemName}-anonymous-cognito"
  assume_role_policy = data.aws_iam_policy_document.identity-pool-assume-role.json
}

resource "aws_iam_role_policy" "allow-cognito-anonymous" {
  name = "${var.systemName}-cognito-anonymous"
  role = aws_iam_role.cognito-anonymous.id
  policy = data.aws_iam_policy_document.cognito-authenticated.json
}

resource "aws_iam_role_policy" "allow-cognito-identified" {
  name = "${var.systemName}-cognito-identified"
  role = aws_iam_role.cognito-identified.id
  policy = data.aws_iam_policy_document.cognito-authenticated.json
}

resource "aws_iam_role" "sns" {
  name = "${var.systemName}-sns"
  assume_role_policy = data.aws_iam_policy_document.sns-assume-role.json
}

resource "aws_iam_policy" "sns" {
  name = "${var.systemName}-sns"
  description = "allow send sns"
  policy = data.aws_iam_policy_document.sns.json
}

resource "aws_iam_policy_attachment" "allow-sns" { # <- attach role to policy
  name = "${var.systemName}-sns-attachment"
  roles = [aws_iam_role.sns.name]
  policy_arn = aws_iam_policy.sns.arn
}
