variable "aws_region" {
  type        = string
  description = "default region "
  default     = "us-west-1"
}

variable "lambda_function_name" {
  type        = string
  description = " lambda function name"
  default     = "greet_lambda"
}
