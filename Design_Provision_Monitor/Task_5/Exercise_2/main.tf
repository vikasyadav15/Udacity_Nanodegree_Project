provider "aws" {
  region                  = var.aws_region
    shared_credentials_file ="~/.aws/credentials"

}

resource "aws_cloudwatch_log_group" "cloudwatch_lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 1
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}



variable "runtime" {
  default = "python3.6"
}

data "archive_file" "zip_file" {
  type        = "zip"
  source_file = "/home/ec2-user/starter_Code/cand-c2-project/Exercise_2/greet_lambda.py"
  output_path = "/home/ec2-user/starter_Code/cand-c2-project/Exercise_2/lambda_helloworld.zip"
}

resource "aws_lambda_function" "lambda_function" {
  role             = "${aws_iam_role.lambda_exec_role.arn}"
  handler          = "${var.lambda_function_name}.lambda_handler"
  runtime          = "${var.runtime}"
  filename         = "lambda_helloworld.zip"
  function_name    = var.lambda_function_name
 source_code_hash = data.archive_file.zip_file.output_base64sha256
 environment {
    variables = {
      greeting = "Hello World"
    }
  }
 depends_on = [aws_cloudwatch_log_group.cloudwatch_lambda_log_group, aws_iam_role_policy_attachment.lambda_logs]
}

resource "aws_iam_role" "lambda_exec_role" {
  name        = "lambda_exec"
  path        = "/"
  description = "Allows Lambda Function to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
