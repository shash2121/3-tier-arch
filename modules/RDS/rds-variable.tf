variable "subnet_ids" {
  type = list
}
variable "storage_capacity" {
  type        = number
  description = "The amount of allocated storage for RDS instance (in GB)"
  default     = 20
}
variable "storage_type" {
  type        = string
  description = "Type of storage"
  default     = "gp2"
}
variable "db_engine" {
  type        = string
  description = "The name of the database engine to be used for the RDS instance"
  default     = null
}
variable "db_engine_version" {
  type        = string
  description = "The database engine version"
  default     = null
}
variable "instance_class" {
  type        = string
  description = "The instance class for RDS"
}
variable "maintenance_window" {
  description = "The window to perform maintenance in UTC. Syntax: `ddd:hh24:mi-ddd:hh24:mi`. Eg: `Mon:00:00-Mon:03:00`"
  type        = string
  default     = null
}
variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: `09:46-10:16`"
  type        = string
  default     = null
}
variable "storage_encryption" {
  description = "enable/disable storage encryption"
  type        = bool
  default     = false
}
variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance"
  type        = number
  default     = 0
}
variable "backup_retention_period" {
  type        = number
  description = "The backup retention period (in days)."
  default     = 30
}
variable "family" {
  description = "family of the RDS instance"
  type        = string
}
variable "multi_az" {
  type        = bool
  description = "Specify if the RDS instance is multi-AZ"
  default     = false
}
variable "replicate_source_db" {
  description = "Specifies source db for read replica"
  type        = string
  default     = null
}
variable "security_group_ids" {
  default = null
}
variable "passwd" {
  type = string
}

variable "master_username" {
  type = string
}



variable "parameter_group_name" {
}
variable "identifier" {
  
}