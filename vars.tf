variable "project_name" {
  default = "nginxCustomContent"
}

variable "region" {
  default = "us-east-1"
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "priv_ips" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "pub_ips" {
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "ami" {
  default = "ami-0c4f7023847b90238"
}

variable "KeyPair" {
  default = "nginx-custom"
}

variable "targets" {
  description = "Targets for targets group"
  type        = map(string)
  default     = {}
}

variable "lb_name" {
  type    = string
  default = ""
}