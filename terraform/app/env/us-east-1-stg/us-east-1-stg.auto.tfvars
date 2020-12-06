# Environment specific variables for stg in us-east-1
env            = "stg"
region         = "us-east-1"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1Mq8zN6vgqflwx1A9nr0h5w4M3+Y5iws1TuQ093y4mAWVnp8RGYT3KYo09QYGDnRWfqLc1No15W4GARZzXYc25WhE6cqUHMozW5Hs/jJRVCfzhGHgHshItdzEheqEOWL+d1fP1yH58hHeMokc4t3sR8571pJkgVNf9TrG1tPZzHIMNxgPjkd82N4GAqI84bw++HzovXUHb/pafb8Jnf8JwzLgm0z1/6fFH8+ICnlSd6x6Whn+xUFcFEU/X3cTgjIsy+SdkbbkrZYrnMNVjsuOi8t38dicriX4Nr8jc5s58FYxvEvZq43WBS8QQBu6bPTkA+Uu+IW1OnCBqA8eiD2r tes-npd"

instance_types = {
  cm1       = "m6g.8xlarge"
  cm2       = "m6g.8xlarge"
  backup    = "m6g.8xlarge"
  fault_mon = "m6g.4xlarge"
  primary   = "m6g.8xlarge"
  jump      = "m6g.4xlarge"
}

instance_counts = {
  cm1       = 1
  cm2       = 1
  primary   = 1
  jump      = 0
  backup    = 0
  fault_mon = 0
}

# Tidal uat DB vars

db_instance_class = "db.m5.large"
db_name           = "TESSTG"
db_storage_size   = 100
db_multi_az       = "false"
