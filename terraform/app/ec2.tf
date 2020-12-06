
resource "aws_instance" "primary" {
  count            = var.instance_counts["primary"]
  ami              = data.aws_ami.centos.id
  instance_type    = var.instance_types["primary"] # make this a variable if you want different instance type based on environment
  subnet_id        = local.private_subnet_ids[0]   # select one of the private subnets to deploy your instance
  private_ip       = cidrhost(local.private_subnet_cidr_map[element(local.private_subnet_ids, count.index)], 4)
  key_name         = aws_key_pair.main.key_name
  user_data_base64 = base64encode(local.instance-userdata)

  root_block_device {
    volume_size           = 10
    volume_type           = "gp2"
    encrypted             = true
    kms_key_id            = aws_kms_key.shared.arn
    delete_on_termination = true
  }

  vpc_security_group_ids = [
    aws_security_group.primary.id,    # security group for your application that can allow access from LBs or be added to other systems like RDS
    aws_security_group.remote.id,     # security group for SSH remote access
    aws_security_group.monitoring.id, # security group for allowing prometheus to scrape metrics
  ]

  lifecycle {
    ignore_changes = [root_block_device, user_data_base64]
  }

  tags = merge(local.required_tags, map(
    "Name", join("-", [local.prefix, "primary"]),
    "lll:deployment:role", "primary",                    # The role of the server. Normally same as Ansible role/group. Will show up in alerts.
    "lll:monitoring:node-exporter", "enabled",           # This allow Prometheus to discover your instance automatically
    "lll:monitoring:owner", join("-", [var.app, "eng"]), # Change this to match the alert receiver in Alertmanager
  ))
}

resource "aws_instance" "backup" {
  count            = var.instance_counts["backup"]
  ami              = data.aws_ami.centos.id
  instance_type    = var.instance_types["backup"] # make this a variable if you want different instance type based on environment
  subnet_id        = local.private_subnet_ids[0]  # select one of the private subnets to deploy your instance
  private_ip       = cidrhost(local.private_subnet_cidr_map[element(local.private_subnet_ids, count.index)], 1)
  key_name         = aws_key_pair.main.key_name
  user_data_base64 = base64encode(local.instance-userdata)

  root_block_device {
    volume_size           = 10
    volume_type           = "gp2"
    encrypted             = true
    kms_key_id            = aws_kms_key.shared.arn
    delete_on_termination = true
  }

  vpc_security_group_ids = [
    aws_security_group.primary.id,    # security group for your application that can allow access from LBs or be added to other systems like RDS
    aws_security_group.remote.id,     # security group for SSH remote access
    aws_security_group.monitoring.id, # security group for allowing prometheus to scrape metrics
  ]

  lifecycle {
    ignore_changes = [root_block_device, user_data_base64]
  }

  tags = merge(local.required_tags, map(
    "Name", join("-", [local.prefix, "backup"]),
    "lll:deployment:role", "backup",                     # The role of the server. Normally same as Ansible role/group. Will show up in alerts.
    "lll:monitoring:node-exporter", "enabled",           # This allow Prometheus to discover your instance automatically
    "lll:monitoring:owner", join("-", [var.app, "eng"]), # Change this to match the alert receiver in Alertmanager
  ))
}

resource "aws_instance" "fault_mon" {
  count            = var.instance_counts["fault_mon"]
  ami              = data.aws_ami.centos.id
  instance_type    = var.instance_types["fault_mon"] # make this a variable if you want different instance type based on environment
  subnet_id        = local.private_subnet_ids[0]     # select one of the private subnets to deploy your instance
  private_ip       = cidrhost(local.private_subnet_cidr_map[element(local.private_subnet_ids, count.index)], 7)
  key_name         = aws_key_pair.main.key_name
  user_data_base64 = base64encode(local.instance-userdata)

  root_block_device {
    volume_size           = 10
    volume_type           = "gp2"
    encrypted             = true
    kms_key_id            = aws_kms_key.shared.arn
    delete_on_termination = true
  }

  vpc_security_group_ids = [
    aws_security_group.fault_mon.id,  # security group for your application that can allow access from LBs or be added to other systems like RDS
    aws_security_group.remote.id,     # security group for SSH remote access
    aws_security_group.monitoring.id, # security group for allowing prometheus to scrape metrics
  ]

  lifecycle {
    ignore_changes = [root_block_device, user_data_base64]
  }

  tags = merge(local.required_tags, map(
    "Name", join("-", [local.prefix, "fault_mon"]),
    "lll:deployment:role", "fault_mon",                  # The role of the server. Normally same as Ansible role/group. Will show up in alerts.
    "lll:monitoring:node-exporter", "enabled",           # This allow Prometheus to discover your instance automatically
    "lll:monitoring:owner", join("-", [var.app, "eng"]), # Change this to match the alert receiver in Alertmanager
  ))
}

resource "aws_instance" "cm1" {
  count            = var.instance_counts["cm1"]
  ami              = data.aws_ami.centos.id
  instance_type    = var.instance_types["cm1"]   # make this a variable if you want different instance type based on environment
  subnet_id        = local.private_subnet_ids[0] # select one of the private subnets to deploy your instance
  private_ip       = cidrhost(local.private_subnet_cidr_map[element(local.private_subnet_ids, count.index)], 6)
  key_name         = aws_key_pair.main.key_name
  user_data_base64 = base64encode(local.instance-userdata)

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
    encrypted   = true
    kms_key_id  = aws_kms_key.shared.arn
    # delete_on_termination = true
  }

  vpc_security_group_ids = [
    aws_security_group.cm.id,         # security group for your application that can allow access from LBs or be added to other systems like RDS
    aws_security_group.remote.id,     # security group for SSH remote access
    aws_security_group.monitoring.id, # security group for allowing prometheus to scrape metrics
  ]

  lifecycle {
    ignore_changes = [root_block_device, user_data_base64]
  }

  tags = merge(local.required_tags, map(
    "Name", join("-", [local.prefix, "cm1"]),
    "lll:deployment:role", "cm1",                        # The role of the server. Normally same as Ansible role/group. Will show up in alerts.
    "lll:monitoring:node-exporter", "enabled",           # This allow Prometheus to discover your instance automatically
    "lll:monitoring:owner", join("-", [var.app, "eng"]), # Change this to match the alert receiver in Alertmanager
  ))
}

resource "aws_instance" "cm2" {
  count            = var.instance_counts["cm2"]
  ami              = data.aws_ami.centos.id
  instance_type    = var.instance_types["cm2"]   # make this a variable if you want different instance type based on environment
  subnet_id        = local.private_subnet_ids[0] # select one of the private subnets to deploy your instance
  private_ip       = cidrhost(local.private_subnet_cidr_map[element(local.private_subnet_ids, count.index)], 5)
  key_name         = aws_key_pair.main.key_name
  user_data_base64 = base64encode(local.instance-userdata)

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
    encrypted   = true
    kms_key_id  = aws_kms_key.shared.arn
    # delete_on_termination = true
  }

  vpc_security_group_ids = [
    aws_security_group.cm.id,         # security group for your application that can allow access from LBs or be added to other systems like RDS
    aws_security_group.remote.id,     # security group for SSH remote access
    aws_security_group.monitoring.id, # security group for allowing prometheus to scrape metrics
  ]

  lifecycle {
    ignore_changes = [root_block_device, user_data_base64]
  }

  tags = merge(local.required_tags, map(
    "Name", join("-", [local.prefix, "cm2"]),
    "lll:deployment:role", "cm2",                        # The role of the server. Normally same as Ansible role/group. Will show up in alerts.
    "lll:monitoring:node-exporter", "enabled",           # This allow Prometheus to discover your instance automatically
    "lll:monitoring:owner", join("-", [var.app, "eng"]), # Change this to match the alert receiver in Alertmanager
  ))
}
