# You can create local variables using locals and reference it elsewhere.
locals {
  prefix = join("-", [var.env, var.app])
}
