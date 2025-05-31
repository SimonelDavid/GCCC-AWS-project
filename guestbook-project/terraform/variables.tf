variable "aws_region" {
  default = "eu-central-1"
}

variable "ami_id" {
  description = "AMI ID for Amazon Linux 2 in eu-central-1"
  default     = "ami-0faab6bdbac9486fb"
}

variable "instance_type" {
  default = "t3.nano"
}

variable "key_pair_name" {
  description = "SSH key pair name"
  type        = string
}

variable "s3_bucket_name" {
  description = "Bucket for image storage"
  type        = string
}

variable "db_username" {
  description = "RDS DB username"
  type        = string
}

variable "db_password" {
  description = "RDS DB password"
  type        = string
  sensitive   = true
}