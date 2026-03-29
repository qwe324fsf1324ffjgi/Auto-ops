resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${local.name_prefix}-lambda"
  retention_in_days = 7

  tags = local.common_tags
}

resource "aws_lambda_function" "self_heal" {
  function_name = "${local.name_prefix}-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime

  filename         = "${path.module}/../lambda/autoops_lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/autoops_lambda.zip")

  timeout     = 30
  memory_size = 128

  environment {
    variables = {
      EC2_PUBLIC_IP         = aws_instance.app.public_ip
      EC2_INSTANCE_ID       = aws_instance.app.id
      DOCKER_CONTAINER_NAME = "autoops-nginx"
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda
  ]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-lambda"
  })
}