provider "aws"{
    
}
resource "aws_instance" "test" {
    ami="ami-0885b1f6bd170450c"
    availablility_zone="us-east-1a"
    instance_type="t2.nano"
    tags={
        name="farhan"
    }

  
}