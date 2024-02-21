variable "lambda_function_name" {
  description = "[REQUIRED] The name of the Lambda function."
  type        = string
}

variable "lambda_timeout" {
  description = "[OPTIONAL] The amount of time (in seconds) that Lambda allows a function to run before stopping it."
  type        = number

  default = 900

  validation {
    condition     = var.lambda_timeout >= 3 && var.lambda_timeout <= 900
    error_message = "The value must be between 3 and 900."
  }
}

variable "cloudwatch_logs_retention" {
  description = "[OPTIONAL] The number of days log events are kept in CloudWatch Logs for the Lambda function."
  type        = number
  default     = 14

  validation {
    condition = (
      var.cloudwatch_logs_retention == 0 || # 0 means never expire
      var.cloudwatch_logs_retention == 1 ||
      var.cloudwatch_logs_retention == 3 ||
      var.cloudwatch_logs_retention == 5 ||
      var.cloudwatch_logs_retention == 7 ||
      var.cloudwatch_logs_retention == 14 ||
      var.cloudwatch_logs_retention == 30 ||
      var.cloudwatch_logs_retention == 60 ||
      var.cloudwatch_logs_retention == 90 ||
      var.cloudwatch_logs_retention == 120 ||
      var.cloudwatch_logs_retention == 150 ||
      var.cloudwatch_logs_retention == 180 ||
      var.cloudwatch_logs_retention == 365 ||
      var.cloudwatch_logs_retention == 400 ||
      var.cloudwatch_logs_retention == 545 ||
      var.cloudwatch_logs_retention == 731 ||
      var.cloudwatch_logs_retention == 1827 ||
      var.cloudwatch_logs_retention == 3653
    )
    error_message = "The value must be one of the followings: 0,1,3,5,7,14,30,60,90,120,150,180,365,400,545,731,1827,3653."
    # Reference: https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_PutRetentionPolicy.html
  }
}
