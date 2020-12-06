# example of deploying an EC2 instance with latest Centos AMI and required 
# security groups for remote access and monitoring. A userdata example on how
# to bootstrap you system and install Prometheus Node exporter for monitoring.

## required files:
# locals.tf
# ami.tf
# security_group.tf
# ssh_key.tf
resource "aws_instance" "web" {
  ami              = data.aws_ami.centos.id
  instance_type    = "t2.micro"                  # make this a variable if you want different instance type based on environment
  subnet_id        = local.private_subnet_ids[0] # select one of the private subnets to deploy your instance
  key_name         = aws_key_pair.main.key_name
  user_data_base64 = base64encode(local.instance-userdata)


  vpc_security_group_ids = [
    aws_security_group.web.id,        # security group for your application that can allow access from LBs or be added to other systems like RDS
    aws_security_group.remote.id,     # security group for SSH remote access
    aws_security_group.monitoring.id, # security group for allowing prometheus to scrape metrics
  ]

  # Setting tags by merging required tags and adding Name and monitoring tags
  # follow this guide for enabling monitoring on your EC2 instances
  # https://lululemon.atlassian.net/wiki/spaces/GSS/pages/1178769522/System+Monitoring
  tags = merge(local.required_tags, map(
    "Name", join("-", [local.prefix, "web"]),
    "lll:deployment:role", "web",                        # The role of the server. Normally same as Ansible role/group. Will show up in alerts.
    "lll:monitoring:node-exporter", "enabled",           # This allow Prometheus to discover your instance automatically
    "lll:monitoring:owner", join("-", [var.app, "eng"]), # Change this to match the alert receiver in Alertmanager
  ))
}

# You can use userdata to bootstrap your instances. Here is an example we install 
# Prometheus Node exporter
# Note: this is not the prefered method and just an example of how you can bootstrap
# your instance using userdata
locals {
  instance-userdata = <<USERDATA
#!/bin/bash

set -e

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

export PATH=$PATH:/usr/local/bin

useradd --no-create-home --shell /bin/false node_exporter
cd /tmp
curl -LO "https://github.com/prometheus/node_exporter/releases/download/v0.18.0/node_exporter-0.18.0.linux-amd64.tar.gz"
tar xvzf node_exporter-0.18.0.linux-amd64.tar.gz

mkdir -p /opt/node_exporter
mv node_exporter-0.18.0.linux-amd64/node_exporter /opt/node_exporter/
rm -rf /tmp/node_exporter-0.18.0.linux-amd64

cat << EOF > /lib/systemd/system/node-exporter.service
[Unit]
Description=Prometheus agent
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=/opt/node_exporter/node_exporter
[Install]
WantedBy=multi-user.target
EOF

systemctl enable node-exporter
systemctl start node-exporter
  
USERDATA
}
