
# resource "aws_autoscaling_group" "tes_auto_scaling" {
#   name                = "tes_auto_scaling"
#   max_size            = 2
#   min_size            = 2
#   health_check_type   = "EC2"
#   desired_capacity    = 2
#   force_delete        = true
#   vpc_zone_identifier = [local.private_subnet_ids[0], local.private_subnet_ids[1]]

#   launch_template {
#     id      = aws_launch_template.cm_servers.id
#     version = "$Latest"
#   }

# }
