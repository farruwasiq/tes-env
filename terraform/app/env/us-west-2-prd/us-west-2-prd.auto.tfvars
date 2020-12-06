# Environment specific variables for prd in us-west-2
env            = "prd"
region         = "us-west-2"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTsnnksD/68WzXO6fmvFfEGBfWqU43fYyosjkHgQgEaemL8a0NGRfQB2pZUKYlV9fV9aHgU+mIX3Sm3WukDQ6CZR2rebhnPCUcz1oMiMOkdd34WITeSRvA0UKEXlifV9GmRzuGWWqzjxF3qaXacmSFJDsNZ6tBtY+9Wp4Ccb76nHjfoBKYzYRuyGzV+Du/NjX7df32X7shY/o1g1+TzFObGEvrdPLK4akOL8NOmqvB6mHui7izPh/Vf/pXpo3yKrhdLhTMQsjesxhVV4sSpVzu/KjDV/iE5ScrIlfYujJmQdqIkKd0HOMnqPl4iwi1fziR8VwqggWzRmrNQ3W+WrXN tes-prod"

instance_types = {
  cm1       = "m6g.8xlarge"
  cm2       = "m6g.8xlarge"
  primary   = "m6g.8xlarge"
  backup    = "m6g.8xlarge"
  fault_mon = "m6g.4xlarge"
  jump      = "t4g.large"
}

instance_counts = {
  cm1       = 1
  cm2       = 1
  primary   = 1
  backup    = 1
  fault_mon = 1
  jump      = 1
}

# Tidal prod DB vars

db_instance_class          = "db.m5.large"
db_name                    = "TESPRD"
db_storage_size            = 200
db_multi_az                = "true"
db_apply_immediately       = "false"
db_backup_retention_period = 14
