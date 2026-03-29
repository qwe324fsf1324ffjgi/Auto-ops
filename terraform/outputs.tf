output "vpc_id" {
  description = "ID of the project VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID of the EC2 security group."
  value       = aws_security_group.ec2.id
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.app.id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance."
  value       = aws_instance.app.public_ip
}

output "lambda_function_name" {
  description = "Name of the Lambda self-healing function."
  value       = aws_lambda_function.self_heal.function_name
}

output "lambda_log_group_name" {
  description = "CloudWatch log group for the Lambda function."
  value       = aws_cloudwatch_log_group.lambda.name
}

output "scheduler_name" {
  description = "Name of the EventBridge Scheduler schedule."
  value       = aws_scheduler_schedule.autoops.name
}