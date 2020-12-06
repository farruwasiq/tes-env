# An example of deploying an RDS instance with default naming.

## required files:
# security_group.tf
# locals.tf

# required information in the form of variables:
# db_subnet_group_name: name of subnet group defined in your VPC 
#   should be public.
# vpc_security_group_ids: list of 1+ security groups you setup for RDS.
#   Typically, this is setup in security_group.tf in your app/ folder.
#   ie. ["sg-12345678","sg-23456789"]
# tags: any other miscellaneous tags you wish to add. Map variable.
module "db" {
  source  = "terraform.lululemon.app/lululemon/rds-lll/aws"
  version = ">=1.5" # >= 1.5, < 2.0. Follow the module release notes and 'bump'

  # dbIdentifier/instance for your DB.  If you leave this blank, identifier
  # is auto-created using lll_server_name provider ie. "abd-myapp"
  identifier        = "abd-myapp"
  engine            = "oracle-ee"
  engine_version    = "19.0.0.0.ru-2020-04.rur-2020-04.r1"
  environment       = var.env
  instance_class    = "db.t3.medium" # make this a variable if you want different db instance type based on environment
  allocated_storage = 20
  region            = local.region
  storage_encrypted = false

  license_model = "bring-your-own-license"
  name          = "DEMOB1"
  username      = "awssys"
  password      = "ThisIsATestPassword" // Set this as a variable in TFE UI
  port          = "1521"

  db_subnet_group_name = local.private_subnet_ids[1] # select one of the private subnets to deploy your dbs
  maintenance_window   = "Mon:00:00-Mon:03:00"
  backup_window        = "03:00-06:00"

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  # disable backups to create DB faster
  backup_retention_period = 0

  # Setting tags by merging required tags and adding Name and monitoring tags
  tags = merge(local.required_tags, map(
    "Name", join("-", [local.prefix, "web"]),
    "lll:business:database-steward", "dba-or-app-team@lululemon.com", # as a notification email for SNS alerts or other escalations specificto the database
    "lll:monitoring:owner", join("-", [var.app, "eng"]),              # Change this to match the alert receiver in Alertmanager
  ))
}


