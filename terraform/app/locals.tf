# You can create local variables using locals and reference it elsewhere.
locals {
  prefix = join("-", [var.env, var.app])
}

locals {
  region                     = data.aws_region.current.name
  account_id                 = data.aws_caller_identity.current.account_id
  vpc_id                     = data.aws_vpc.main.id
  vpc_cidrs                  = sort([for s in data.aws_vpc.main.cidr_block_associations : s.cidr_block])
  availability_zones         = sort([for s in data.aws_subnet.private : s.availability_zone])
  private_subnet_ids         = sort(data.aws_subnet_ids.private.ids)
  private_subnet_cidr_blocks = sort([for s in data.aws_subnet.private : s.cidr_block])
  private_subnet_cidr_map    = { for s in data.aws_subnet.private : s.id => s.cidr_block }
  public_subnet_ids          = sort(data.aws_subnet_ids.public.ids)
  public_subnet_cidr_blocks  = sort([for s in data.aws_subnet.public : s.cidr_block])

  required_tags = {
    "tfe_workspace"                 = var.tfe_workspace
    "lll:deployment:environment"    = var.env
    "lll:deployment:automation"     = "terraform"
    "lll:business:application-name" = "tes"
    "lll:business:department"       = "Infrastructure"
    "lll:business:project-code"     = "2010030131"
    "lll:business:project-name"     = "TES 2020 Upgrades"
    "lll:business:cost-center"      = "0041"
    "lll:security:compliance"       = "none"
    "lll:business:steward"          = "infra-cloudplatform@lululemon.com"
  }

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
