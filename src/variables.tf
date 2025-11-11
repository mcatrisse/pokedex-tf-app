variable "create_iam_role" {
    type = bool
    default = false
}

variable "region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}