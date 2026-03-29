variable "aws_region" {
  description = "AWS region where all resources will be created."
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Project name used in all resource names."
  type        = string
  default     = "autoops"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner tag for resources."
  type        = string
  default     = "Zerah"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet."
  type        = string
  default     = "eu-north-1a"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Optional EC2 key pair name for SSH access."
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the EC2 instance."
  type        = string
  default     = "0.0.0.0/0"
}

variable "lambda_runtime" {
  description = "Python runtime for Lambda."
  type        = string
  default     = "python3.12"
}

variable "lambda_handler" {
  description = "Lambda handler entry point."
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_schedule_expression" {
  description = "How often EventBridge Scheduler triggers Lambda."
  type        = string
  default     = "rate(5 minutes)"
}