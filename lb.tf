resource "aws_lb" "tes_lb" {
  name = "tes-lb"

  subnets         = ["${aws_subnet.dev_subnet_public_1a.id}"]
  load_balancer_type = "application"
  security_groups = ["${aws_security_group.lb_sg.id}"]
  #instances       = ["${aws_instance.dev_tes_cm1.id}", "${aws_instance.dev_tes_cm2.id}"]
  enable_deletion_protection = true
  tags = {
    Environment = "production"
  }

}


