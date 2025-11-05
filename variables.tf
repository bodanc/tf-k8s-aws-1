variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "enable_dns_hostnames" {
  description = ""
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = ""
  type        = bool
  default     = false
}

variable "ec2_instance_type" {
  description = ""
  type        = string
  default     = "t2.medium"
}


# locals

variable "created_by" {
  description = ""
  type        = string
  default     = ""
}

variable "company" {
  description = ""
  type        = string
  default     = ""
}

variable "project" {
  description = ""
  type        = string
  default     = ""
}

variable "environment" {
  description = ""
  type        = string
  default     = ""
}
