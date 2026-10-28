variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-south-1"
}

variable "availability_zone" {
  description = "Availability zone for both assignment subnets"
  type        = string
  default     = "ap-south-1a"
}

variable "admin_ip" {
  description = "Public IPv4 address allowed to SSH into the web server, without CIDR suffix"
  type        = string

  validation {
    condition     = can(cidrhost("${var.admin_ip}/32", 0))
    error_message = "admin_ip must be a valid IPv4 address."
  }
}

variable "key_name" {
  description = "Name of the existing AWS EC2 key pair"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
