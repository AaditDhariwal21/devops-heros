variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_prefix" {
  description = "start of the bucket name (a random suffix is added because names are global)"
  type        = string
}

variable "environment" {
  description = "used in tags"
  type        = string
  default     = "dev"
}
