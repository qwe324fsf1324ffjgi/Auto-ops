locals {
  # Keeping naming logic here avoids mistakes across files.
  name_prefix = "${var.project_name}-${var.environment}"

  # Shared tags help with cost tracking, cleanup, and professionalism.
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
  }
}