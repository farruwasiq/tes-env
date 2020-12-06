# Use security groups to control access to your resources
# You can attach multiple security groups to resources like EC2 instances, RDS

## required files:
# locals.tf
resource "aws_security_group" "remote" {
  name        = join("-", [local.prefix, "remote"])
  description = "Allow SSH access to instances"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow SSH from Lululemon internal network"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = merge(local.required_tags, map("Name", join("-", [local.prefix, "remote"])))
}

# Allow Sharedservices Prometheus to access Node exporter on port 9100
# to scrape metrics for monitoring
resource "aws_security_group" "monitoring" {
  name        = join("-", [local.prefix, "monitoring"])
  description = "Allow SSH access to instances"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow Prometheus to scrape Node exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"

    cidr_blocks = [
      "10.212.8.0/24",  # Sharedservices CIDR
      "10.212.16.0/24", # Sharedservices CIDR
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = merge(local.required_tags, map("Name", join("-", [local.prefix, "monitoring"])))
}

# Example of application security group that can be used to limit access to
# some of the ports that your application runs on or can be used to allow your
# application to access other resources like RDS
resource "aws_security_group" "web" {
  name        = join("-", [local.prefix, "web"])
  description = "Web Server"
  vpc_id      = local.vpc_id

  ingress {

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8", # Lululemon internal network
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.required_tags, map("Name", join("-", [local.prefix, "web"])))
}

# Example security group for RDS databases.
# Allow App layer to access DB on port 1521 (Oracle port).
# Change this for your specific environment (ie. diff port for your engine,
# and diff IP-range or security group for your app-servers/corp CIDR).
resource "aws_security_group" "rds" {
  name        = join("-", [local.prefix, "rds"])
  description = "Allow inbound access to RDS"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow app-servers to access DB"
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"

    security_groups = [
      aws_security_group.web.id # Allow your web server to access the DB
    ]

    # Change this to Bastion Host, or On-prem corp CIDR.
    cidr_blocks = [
      "10.212.8.0/24",  # Sharedservices CIDR
      "10.212.16.0/24", # Sharedservices CIDR
    ]
  }

  # default to corp CIDR
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = merge(local.required_tags, map("Name", join("-", [local.prefix, "rds"])))
}

