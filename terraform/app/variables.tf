variable "app" {
  type        = string
  description = "Application We're building"
}

variable "env" {
  type        = string
  description = "Environment We're building for"
}

variable "region" {
  type        = string
  description = "AWS region we are deploying our resources"
}

variable "tfe_workspace" {
  type        = string
  description = "Terraform Enterprise workspace name"
  default     = "tes-app"
}

variable "trigger_refresh" {
  type        = string
  description = "Changing the value of this variable will force referesh the outputs"
  default     = ""
}

variable "instance_types" {
  type        = map(string)
  description = "EC2 Instance types"
}

variable "instance_counts" {
  type        = map(string)
  description = "EC2 Instance types"
}

variable "allowed_sources" {
  type        = string
  description = "Lulu CIDR"
}



# db variables
/*
variable "db_admin_user" {
  description = "Name of DB Admin account"
  type        = string
}

variable "db_admin_password" {
  description = "Password for DB Admin account"
  type        = string
}

variable "db_engine_name" {
  description = "Name of the DB engine (e.g. oracle-ee or sqlserver-ee)"
  type        = string
}

variable "db_engine_version" {
  description = "The specific RDS engine to run (e.g. 12.1.0.2.v11)"
  type        = string
}

variable "db_instance_class" {
  description = "class/type of the instance running the Database"
  type        = string
}

variable "db_name" {
  description = "The name of the RDS instance."
  type        = string
}

variable "db_storage_size" {
  description = "How much disk space to allocate to RDS instance (GB)"
  type        = number
}

variable "db_max_allocated_storage" {
  description = "max autoscaling size.  0 = disabled."
  type        = number
}

variable "db_storage_type" {
  description = "Type of storage to use for RDS (e.g. gp2/io1/standard)"
  type        = string
}

variable "db_multi_az" {
  description = "Set up RDS instance to use multi AZs"
  type        = string
}

variable "db_backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
}

variable "db_maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
}

variable "db_backup_retention_period" {
  description = "The number of daily automatic backups to keep (default and max: 35)"
  type        = string
  default     = 7
}
variable "db_port" {
  description = "The port on which the DB accepts connections"
  type        = string
}

variable "db_license_model" {
  description = "License model information for this DB instance. Optional. Oracle: use bring-your-own-license"
  type        = string
}

variable "db_apply_immediately" {
  description = "True/False whether to apply any changes immediately or wait for reboot."
  type        = string
  default     = "true"
}
*/
variable "ssh_public_key" {
  description = "Public Key of SSH key to use for This Environment"
}
