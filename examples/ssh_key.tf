# This resource will create an ssh key that you can refrence while creating EC2 instance
# Generate your own key pairs with `ssh-keygen` command and replace the public key
# You can then use the private key to SSH into your Linux machines or geet the credentials
# for your Windows instances

## required files:
# locals.tf
resource "aws_key_pair" "main" {
  key_name   = join("-", [local.prefix, "key"])
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtVtNZoEW1DyBP7DmcgeuJ5K4A/3grKbYOCo8/IoQj9sionGF5YSsjd5przpGil79GFIOEtyYZ3c1Jml+GQHilPiF8IUgvfed9Re1cbOlXWC8gvEXPWxP0nZ2z79hzZIJKjyZdthJMYPLHHtuYAZgX8yE0/hQyU0Wb3y5bnwWoYh2hxdmZWS9kKnGRnJrtnzLKr4SmJRN4jEgVnjW+IKPYkZiYQKn85ym/ScUlNUjdN4ZMptsPUdEaTCLORK8QKDOpw0sB7nb2Em0nkI5mkwJJScjzWrfFbBYO1/f7NI6Qd3LHbE+2hkLwzzIAHm45zDsh9PYy2ubp6wqg6iRHjqab"
}
