provider "aws"{
    region="us-east-1"
}
resource "aws_instance" "test" {
    ami="ami-0885b1f6bd170450c"
    instance_type="t2.nano"
    tags={
        name="farhan"
    }

  
}