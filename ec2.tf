provider "aws"{
    
}
resource "aws_instance" "jenkins-test" {//creaing instance
    ami="ami-0885b1f6bd170450c"
    
    instance_type="t2.nano"
    tags={
        name="farhan"
    }

  
}
resource "aws_s3_bucket" "tf_state"{//creaitng bucket
    bucket="my_tf_state"
    acl="public"
    versioning {
      enabled=true
    }
}