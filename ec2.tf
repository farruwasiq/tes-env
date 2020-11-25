resource "aws_instance" "dev_tes_cm1" {//this is instance in private of subnet
  subnet_id       = aws_subnet.private_subnet.id
  instance_type   = var.instance_type["cm1"]
  vpc_security_group_ids = ["${aws_security_group.my_sg.id}"]
  key_name        = aws_key_pair.ssh.key_name

  ami = lookup(var.ami, var.region)
  tags = {
    name = "dev_cm1"
  }
  root_block_device {
    volume_size           = 10
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.dev_tes_cm1.public_ip} > ip_address.txt"

 
  }

}
output "dev_cm1_private_ip" {
  value = aws_instance.dev_tes_cm1.private_ip

}
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096

}
resource "aws_key_pair" "ssh" {
  key_name   = "dummy"
  public_key = tls_private_key.ssh.public_key_openssh

}
output "ssh_private_key_pem" {
  value = tls_private_key.ssh.private_key_pem

}
output "ssh_public_key_pem" {
  value = tls_private_key.ssh.private_key_pem

}


resource "aws_instance" "jump_host" {
  subnet_id = aws_subnet.public_subnet.id
  ami       = lookup(var.ami, var.region)

  instance_type   = var.instance_type["cm2"]
  key_name        = aws_key_pair.ssh.key_name
  vpc_security_group_ids = ["${aws_security_group.my_sg.id}"]
  tags = {
    name = "jump_host"
  }
  root_block_device {
    volume_size           = 10
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true

  }

}
resource "aws_eip" "jump_eip" {
  instance = aws_instance.jump_host.id
  vpc      = true

}
output "jump_host_ip" {
  value = aws_eip.jump_eip.public_ip

}
