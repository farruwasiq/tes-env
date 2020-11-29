provider "aws"{
    region="us-east-1"
    
}
/*
resource "aws_instance" "jenkins-test" {//creaing instance
    ami="ami-0885b1f6bd170450c"
    key_name="k8-leo"
    
    instance_type="t2.nano"
    tags={
        name="farhan"
    }

  
}
/*
resource "aws_s3_bucket" "tf-state-mine"{//creaitng bucket adf
    bucket="my-tf-state-mine-jenkins"
    acl="private"
    versioning {
      enabled=true
    }
    tags = {
    Name        = "My bucket"
    Environment = "Dev"
    }

}
/*
# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
  tags {
    Name = "DynamoDB Terraform State Lock Table"
  }
}
*/

/*
resource "aws_dynamodb_table" "terraform_state_lock" {//creating dyanmo db table

    name           = "terraform-lock"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "buffer" {//creating bucket
    bucket="buffer-jenkins"
    acl="private"
    versioning {
      enabled=true
    }
    tags = {
    Name        = "My bucket"
    Environment = "prod"
    }

  
}
/*
resource "aws_instance" "my-instance" {
	ami="ami-0885b1f6bd170450c"
	instance_type = "t2.nano"
	key_name = "k8"
	user_data     = <<-EOF
                  #!/bin/bash
                  sudo su
                  apt-get update
                  sudo -y install httpd
                  echo "<p> My Instance! </p>" >> /var/www/html/index.html
                  sudo systemctl enable httpd
                  sudo systemctl start httpd
                  EOF
}
	

*/
resource "aws_s3_bucket" "personal"{
    bucket="my-tf-state-mine-jenkins-terraformbackup"
    acl="private"
    versioning {
      enabled=true
    }
    tags = {
    Name        = "My bucket"
    Environment = "Dev"
    }

}

terraform {
    backend "s3" {

        encrypt = true
        bucket = "my-tf-state-mine-jenkins-terraformbackup"
        key = "terraform.tfstate"
        region = "us-east-1"
        
        }
}

*/