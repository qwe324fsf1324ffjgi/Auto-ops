aws_region                 = "eu-north-1"
project_name               = "autoops"
environment                = "dev"
owner                      = "Zerah"

vpc_cidr                   = "10.0.0.0/16"
public_subnet_cidr         = "10.0.1.0/24"
availability_zone          = "eu-north-1a"

instance_type              = "t3.micro"
key_pair_name              = ""
allowed_ssh_cidr           = "0.0.0.0/0"

lambda_runtime             = "python3.12"
lambda_handler             = "lambda_function.lambda_handler"
lambda_schedule_expression = "rate(5 minutes)"