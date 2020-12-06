# resource "aws_launch_template" "cm_servers" {
#   name = "cm_servers"

#   block_device_mappings {
#     device_name = "/dev/sda1"

#     ebs {
#       volume_size = 50
#     }
#   }

#   credit_specification {
#     cpu_credits = "standard"
#   }

#   disable_api_termination = true

#   ebs_optimized = true

#   #   iam_instance_profile {
#   #     name = "test"
#   #   }

#   image_id = data.aws_ami.centos.id

#   instance_initiated_shutdown_behavior = "terminate"

#   instance_type = var.instance_types["cm1"]

#   key_name = aws_key_pair.main.key_name

#   monitoring {
#     enabled = true
#   }

#   vpc_security_group_ids = [
#     aws_security_group.cm.id,         # security group for your application that can allow access from LBs or be added to other systems like RDS
#     aws_security_group.remote.id,     # security group for SSH remote access
#     aws_security_group.monitoring.id, # security group for allowing prometheus to scrape metrics
#   ]

#   tag_specifications {
#     resource_type = "instance"

#     tags = merge(local.required_tags, map(
#       "Name", join("-", [local.prefix, "cm_servers"]),
#       "lll:deployment:role", "cm_servers",                 # The role of the server. Normally same as Ansible role/group. Will show up in alerts.
#       "lll:monitoring:node-exporter", "enabled",           # This allow Prometheus to discover your instance automatically
#       "lll:monitoring:owner", join("-", [var.app, "eng"]), # Change this to match the alert receiver in Alertmanager
#     ))
#   }

#   user_data = base64encode(local.instance-userdata)

# }
