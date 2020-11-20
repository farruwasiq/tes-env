provider "aws"{
    region="us-easit-1"

}
resource "aws_instance" "test-dev"{
    instnace_type="t2.micro"
    ami=" ami-04bf6dcdc9ab498ca"
    
}