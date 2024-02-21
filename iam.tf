# IAM Policy Source
data "aws_iam_policy_document" "lambda" {
  statement {
    sid    = "CloudWatchAccess"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "logs:PutRetentionPolicy",
      "logs:DeleteRetentionPolicy"
    ]
    resources = ["arn:aws:logs:${local.aws_region}:${local.aws_account_id}:*"]
  }
}

data "aws_iam_policy_document" "lambda_trust" {
  statement {
    sid    = "LambdaAssumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM Policy
resource "aws_iam_policy" "lambda" {
  name        = "${var.lambda_function_name}-Lambda-Policy"
  path        = "/"
  description = "Permissions to trigger the Lambda"
  policy      = data.aws_iam_policy_document.lambda.json
  tags        = { Name = "${var.lambda_function_name}-Lambda-Policy" }
}

# IAM Role (Lambda execution role)
resource "aws_iam_role" "lambda" {
  name               = "${var.lambda_function_name}-Lambda-Role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
  tags               = { Name = "${var.lambda_function_name}-Lambda-Role" }
}

# Attach Role and Policy
resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}
