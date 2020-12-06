# Environment specific variables for dev in us-east-1
env            = "dev"
region         = "us-east-1"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1Mq8zN6vgqflwx1A9nr0h5w4M3+Y5iws1TuQ093y4mAWVnp8RGYT3KYo09QYGDnRWfqLc1No15W4GARZzXYc25WhE6cqUHMozW5Hs/jJRVCfzhGHgHshItdzEheqEOWL+d1fP1yH58hHeMokc4t3sR8571pJkgVNf9TrG1tPZzHIMNxgPjkd82N4GAqI84bw++HzovXUHb/pafb8Jnf8JwzLgm0z1/6fFH8+ICnlSd6x6Whn+xUFcFEU/X3cTgjIsy+SdkbbkrZYrnMNVjsuOi8t38dicriX4Nr8jc5s58FYxvEvZq43WBS8QQBu6bPTkA+Uu+IW1OnCBqA8eiD2r tes-npd"

instance_types = {
  cm1       = "t2.micro"
  cm2       = "t2.micro"
  backup    = "t2.micro"
  fault_mon = "m5a.large"
  primary   = "t2.micro"
  jump      = "t4g.large"
}

instance_counts = {
  cm1       = 1
  cm2       = 1
  primary   = 1
  jump      = 0
  backup    = 0
  fault_mon = 0
}

# Tidal dev DB vars
/*
db_instance_class = "db.t3.medium"
db_name           = "TESDEV"
db_storage_size   = 100
db_multi_az       = "false"
*/