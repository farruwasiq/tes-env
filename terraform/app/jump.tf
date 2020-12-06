resource "aws_instance" "jump" {
  count            = var.instance_counts["jump"]
  ami              = data.aws_ami.windows.id
  instance_type    = var.instance_types["jump"]  # make this a variable if you want different instance type based on environment
  subnet_id        = local.private_subnet_ids[0] # select one of the private subnets to deploy your instance
  private_ip       = cidrhost(local.private_subnet_cidr_map[element(local.private_subnet_ids, count.index)], 7)
  key_name         = aws_key_pair.main.key_name
  user_data_base64 = base64encode(local.instance-userdata)

  vpc_security_group_ids = [
    aws_security_group.jump.id,       # security group for your application that can allow access from LBs or be added to other systems like RDS
    aws_security_group.remote.id,     # security group for SSH remote access
    aws_security_group.monitoring.id, # security group for allowing prometheus to scrape metrics
  ]

  tags = merge(local.required_tags, map(
    "Name", join("-", [local.prefix, "jump"]),
    "lll:deployment:role", "jump",                       # The role of the server. Normally same as Ansible role/group. Will show up in alerts.
    "lll:monitoring:node-exporter", "enabled",           # This allow Prometheus to discover your instance automatically
    "lll:monitoring:owner", join("-", [var.app, "eng"]), # Change this to match the alert receiver in Alertmanager
  ))
}
