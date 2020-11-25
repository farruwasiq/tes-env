variable "vpc_cidr" {
  type        = string
  description = "main vpc cidr"
}
variable "public_subnet" {
  type        = string
  description = "this is public subnet"

}
variable "private_subnet" {
  type        = string
  description = "this is private subnet"

}
variable "instance_type" {
  type        = map(string)
  description = "types of instances"

}
variable "allowed_source" {
  type        = string
  description = "this are open to internet"

}
variable "ami" {
  type        = map
  description = "list of ami's"
  default = {
    us-east-1 = "ami-0885b1f6bd170450c"
    us-west-2 = "ami-07dd19a7900a1f049"
  }


}
variable "region" {

  type    = string
  default = "us-east-1"
}