resource "aws_scheduler_schedule" "autoops" {
  name        = "${local.name_prefix}-schedule"
  description = "Triggers AutoOps Lambda every 5 minutes"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = var.lambda_schedule_expression
  schedule_expression_timezone = "UTC"

  target {
    arn      = aws_lambda_function.self_heal.arn
    role_arn = aws_iam_role.scheduler_role.arn

    input = jsonencode({
      source  = "eventbridge-scheduler"
      project = var.project_name
      env     = var.environment
      action  = "health-check"
    })
  }

  depends_on = [
    aws_iam_role_policy_attachment.scheduler_invoke_lambda
  ]
}