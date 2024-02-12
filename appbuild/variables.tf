variable "vpc" {
  default = null
}

variable "region" {
}

variable "tags" {
  
}
variable "bastion" {
  default = null
}
variable "sg" {
  default = null
}

variable "frontend-asg" {
  default = null
}
variable "backend-asg" {
  default = null
}
variable "rds" {
  default = null
}
variable "tg" {
  default = null
}
variable "listener_rule" {
  default = null
}
variable "alb" {
  default = null
}