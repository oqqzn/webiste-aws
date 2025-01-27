variable "aws_region" {
  type        = string
  description = "Regions to use for AWS resources"
  default     = "us-east-1"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS Hostnames in VPC"
  default     = true
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_public_subnets_cidr_block" {
  type        = list(string)
  description = "CIDR Block for Public Subnets in VPC"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map public ip address on launch for Subnet instances"
  default     = true
}

variable "instance_type" {
  type        = string
  description = "Type of aws instance"
  default     = "t2.micro"
}

variable "ingress_port" {
  type        = number
  description = "Port access for http server"
  default     = 80
}

variable "egress_port" {
  type        = number
  description = "Port access for http server"
  default     = 0
}

variable "company" {
  type        = string
  description = "Name of Company"
  default     = "Christian Friis"
}

variable "project" {
  type        = string
  description = "Personal Website"
}
