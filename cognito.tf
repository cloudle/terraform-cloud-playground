resource "aws_cognito_user_pool" "main" {
  name = var.systemName

  tags = {
    Name : "${var.systemName}-user-pool"
  }

  auto_verified_attributes = ["email"] # <- fields require verification

  password_policy {
    minimum_length    = 6
    require_uppercase = false
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
  }

  sms_configuration {
    external_id    = var.snsExternalId
    sns_caller_arn = aws_iam_role.sns.arn
  }

  schema {
    name                     = "id"
    developer_only_attribute = true
    attribute_data_type      = "String"
    mutable                  = false
    required                 = false

    string_attribute_constraints {
      max_length = 256
      min_length = 1
    }
  }

  schema {
    name                     = "email"
    developer_only_attribute = false
    attribute_data_type      = "String"
    mutable                  = false
    required                 = true

    string_attribute_constraints {
      max_length = 256
      min_length = 7
    }
  }
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.systemName
  user_pool_id = aws_cognito_user_pool.main.id
}

resource "aws_cognito_user_pool_client" "web-client" {
  name                         = "${var.systemName}-web-client"
  user_pool_id                 = aws_cognito_user_pool.main.id
  supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = var.systemName
  allow_unauthenticated_identities = true

  cognito_identity_providers {
    client_id     = aws_cognito_user_pool_client.web-client.id
    provider_name = "cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.main.id}"
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "cognito-roles" {
  identity_pool_id = aws_cognito_identity_pool.main.id

  roles = {
    authenticated   = aws_iam_role.cognito-identified.arn
    unauthenticated = aws_iam_role.cognito-anonymous.arn
  }
}
