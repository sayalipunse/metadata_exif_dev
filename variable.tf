variable "region" {
  type        = string
  default     = "us-east-1"
  description = "default region name"
}

variable "image_test" {
  default = false
}

locals {
  project_name   = "GE Platform Engineer Exercise"
  # Common tags
  common_tags = {
    project_name  = local.project_name
    environment   = "dev"
    project_code  = "dev_01"
    cost_centre   = "C123"
    business_unit = "GEL"
    author_name   = "Sayali-Punse"
    author_email  = "sayali.punse@hotmail.com"
  }
}
