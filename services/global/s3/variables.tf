variable "bucket_name" {
  type        = string
  default     = "test.chaos"
  description = "The name of the S3 bucket. Must be globally unique."
}

variable "table_name" {
  type        = string
  default     = "chaos"
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
}

variable "access_key" {
  description = "AWS access key"
  type        = string
  default     = null
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  default     = null
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

