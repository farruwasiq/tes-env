output "vpc_stack" {
  value = {
    vpc_id                     = local.vpc_id
    vpc_cidrs                  = local.vpc_cidrs
    availability_zones         = local.availability_zones
    private_subnet_ids         = local.private_subnet_ids
    private_subnet_cidr_blocks = local.private_subnet_cidr_blocks
    public_subnet_ids          = local.public_subnet_ids
    public_subnet_cidr_blocks  = local.public_subnet_cidr_blocks
    required_tags              = local.required_tags
  }
}

output "instance_ips" {

  value = {
    for instance in aws_instance.primary :
    instance.id => instance.private_ip
  }
}

output "ssh_public_key" {
  description = "Name of the SSH key pair provisioned on the instance"
  value       = var.ssh_public_key
}

output "tes_lb" {
  value = aws_lb.tes_lb.dns_name
}

#output "db_connection_string" {
#  value = module.rds.endpoint
#}
