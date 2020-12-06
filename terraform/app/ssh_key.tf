# This resource will create an ssh key that you can refrence while creating EC2 instance
# Generate your own key pairs with `ssh-keygen` command and replace the public key
# You can then use the private key to SSH into your Linux machines or geet the credentials
# for your Windows instances

## required files:
# locals.tf
resource "aws_key_pair" "main" {
  key_name   = join("-", [local.prefix, "key"])
  public_key = var.ssh_public_key
}
