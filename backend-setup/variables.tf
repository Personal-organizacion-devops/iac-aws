variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to store Terraform state"
  default     = "s3-tfstate"
}

variable "dynamodb_table_name" {
  type        = string
  description = "Name of the DynamoDB table for Terraform locking"
  default     = "terraform-locks"
}
