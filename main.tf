#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = var.cloudwatch_logs_retention
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code/"
  output_path = "${path.module}/lambda_code_zip/${lower(replace(lower(var.lambda_function_name), "-", "_"))}.zip"
}

resource "aws_lambda_function" "this" {
  filename      = data.archive_file.lambda.output_path
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda.arn
  handler       = "main_handler.lambda_handler"
  description   = var.lambda_function_name
  tags          = { Name = var.lambda_function_name }

  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.11"
  timeout          = var.lambda_timeout

  tracing_config {
    mode = "Active"
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda,
  ]
}