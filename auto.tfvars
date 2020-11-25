vpc_cidr       = "10.212.210.0/24"
public_subnet  = "10.212.210.0/27"
private_subnet = "10.212.210.64/27"
instance_type = {
  cm1 = "t2.micro"
  cm2 = "t2.nano"
}
allowed_source = "0.0.0.0/0"
