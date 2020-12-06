resource "aws_security_group" "remote" {
  name        = join("-", [local.prefix, "remote"])
  description = "Allow SSH access to instances"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow SSH from Lululemon internal network"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_sources]
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
  description = "Allow Prometheus to scrape Node exporter"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow Prometheus to scrape Node exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"

    cidr_blocks = [var.allowed_sources]
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
resource "aws_security_group" "cm" {
  name        = join("-", [local.prefix, "cm"])
  description = "Web Server"
  vpc_id      = local.vpc_id

  # ingress {

  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"

  #   cidr_blocks = [
  #     "10.0.0.0/8", # Lululemon internal network
  #   ]
  # }

  ingress {
    description = "Allow traffic from lb"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"

    cidr_blocks = [var.allowed_sources]

    security_groups = [
      aws_security_group.tes_lb.id
    ]
  }

  ingress {
    description = "Allow traffic from Master and BM"
    from_port   = 6215
    to_port     = 6215
    protocol    = "tcp"

    security_groups = [
      aws_security_group.primary.id
    ]
  }

  ingress {
    description = "Allow traffic from fault_mon"
    from_port   = 6705
    to_port     = 6705
    protocol    = "tcp"

    security_groups = [
      aws_security_group.primary.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = merge(local.required_tags, map("Name", join("-", [local.prefix, "web"])))
}

resource "aws_security_group" "tes_lb" {
  name        = join("-", [local.prefix, "tes_lb"])
  description = "Load balancer"
  vpc_id      = local.vpc_id

  ingress {

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [var.allowed_sources]
  }

  ingress {

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [var.allowed_sources]
  }

  ingress {

    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    cidr_blocks = [var.allowed_sources]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = merge(local.required_tags, map("Name", join("-", [local.prefix, "lb"])))
}

/* TESCache DB 

resource "aws_security_group" "tes_db" {
  name        = join("-", [local.prefix, "tes_db"])
  description = "Allow Database Server"
  vpc_id      = local.vpc_id

  ingress {
    description = "Master – Microsoft SQL Server"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"

    cidr_blocks = [var.allowed_sources]

    security_groups = [
      aws_security_group.cm.id,
    ]
  }

  ingress {
    description = "Master – Oracle"
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"

    cidr_blocks = [var.allowed_sources]

    security_groups = [
      aws_security_group.cm.id,
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = merge(local.required_tags, map("Name", join("-", [local.prefix, "tes_db"])))
}
*/

resource "aws_security_group" "tes_rds_db" {
  name        = join("-", [local.prefix, "tes_rds_db"])
  description = "Allow RDS traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow traffic from Master to Oracle"
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"

    cidr_blocks = [var.allowed_sources]

    security_groups = [
      aws_security_group.primary.id,
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = merge(local.required_tags, map("Name", join("-", [local.prefix, "tes_rds_db"])))
}

resource "aws_security_group" "primary" {
  name        = join("-", [local.prefix, "primary"])
  description = "Allow Application Server"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow traffic from Fault monitor"
    from_port   = 6703
    to_port     = 6703
    protocol    = "tcp"

    security_groups = [
      aws_security_group.fault_mon.id
    ]
  }

  ingress {
    description = "Allow traffic from Java Client"
    from_port   = 6215
    to_port     = 6215
    protocol    = "tcp"

    cidr_blocks = [var.allowed_sources]

  }

  ingress {
    description = "Allow traffic from Java Client"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"

    cidr_blocks = [var.allowed_sources]

  }

  ingress {
    description = "Allow traffic from Adapters"
    from_port   = 6980
    to_port     = 6980
    protocol    = "tcp"

    cidr_blocks = [var.allowed_sources]

  }

  ingress {
    description = "Allow traffic from Agents"
    from_port   = 5912
    to_port     = 5912
    protocol    = "tcp"

    cidr_blocks = [var.allowed_sources]

  }

  ingress {
    description = "Allow traffic from Agents"
    from_port   = 5591
    to_port     = 5591
    protocol    = "tcp"

    cidr_blocks = [var.allowed_sources]

  }

  ingress {
    description = "Allow traffic from web browser"
    from_port   = 9999
    to_port     = 9999
    protocol    = "tcp"

    cidr_blocks = [var.allowed_sources]
  }

  ingress {
    description = "Allow traffic from JDK JConsole"
    from_port   = 1099
    to_port     = 1099
    protocol    = "tcp"

    cidr_blocks = [var.allowed_sources]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = merge(local.required_tags, map("Name", join("-", [local.prefix, "primary"])))
}

resource "aws_security_group" "fault_mon" {
  name        = join("-", [local.prefix, "fault_mon"])
  description = "Allow Application Server"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow Java Client and Fault monitor"
    from_port   = 6705
    to_port     = 6705
    protocol    = "tcp"

    cidr_blocks = [var.allowed_sources]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = merge(local.required_tags, map("Name", join("-", [local.prefix, "fault_mon"])))
}

resource "aws_security_group" "jump" {
  name        = join("-", [local.prefix, "jump"])
  description = "Allow access to jump"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"

    cidr_blocks = [var.allowed_sources]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = merge(local.required_tags, map("Name", join("-", [local.prefix, "jump"])))
}

